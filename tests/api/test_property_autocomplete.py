"""
Tests for property search API and autocomplete functionality.

Tests the AJAX endpoint used by the property autocomplete widget
to ensure proper search, pagination, and permission handling.
"""

import pytest
from django.urls import reverse
from django.contrib.auth import get_user_model
from api.models import Property, Profile

User = get_user_model()


@pytest.fixture
def staff_user(db):
    """Create a staff user with proper profile."""
    user = User.objects.create_user(
        username='staffuser',
        password='testpass123',
        email='staff@test.com'
    )
    Profile.objects.get_or_create(
        user=user,
        defaults={
            'role': 'staff',
            'phone_number': '1234567890'
        }
    )
    return user


@pytest.fixture
def sample_properties(db):
    """Create sample properties for testing."""
    properties = []
    
    # Create 30 properties with different names
    for i in range(30):
        prop = Property.objects.create(
            name=f"Property {i+1:02d}",
            address=f"{i+1} Test Street",
            is_deleted=False
        )
        properties.append(prop)
    
    # Create some deleted properties (should not appear)
    for i in range(5):
        Property.objects.create(
            name=f"Deleted Property {i+1}",
            is_deleted=True
        )
    
    return properties


@pytest.mark.django_db
class TestPropertySearchAPI:
    """Test property search endpoint for autocomplete."""
    
    def test_requires_authentication(self, client):
        """Unauthenticated requests should be rejected."""
        url = reverse('property-search')
        response = client.get(url)
        
        # Should redirect to login
        assert response.status_code == 302
        assert '/accounts/login/' in response.url
    
    def test_search_all_properties(self, client, staff_user, sample_properties):
        """Empty query should return all active properties."""
        client.force_login(staff_user)
        url = reverse('property-search')
        
        response = client.get(url)
        
        assert response.status_code == 200
        data = response.json()
        
        assert 'results' in data
        assert 'has_more' in data
        assert 'total' in data
        assert data['total'] == 30  # Only active properties
        assert len(data['results']) == 20  # Default page size
        assert data['has_more'] is True
    
    def test_search_by_name(self, client, staff_user, sample_properties):
        """Should filter properties by name."""
        client.force_login(staff_user)
        url = reverse('property-search')
        
        response = client.get(url, {'q': 'Property 01'})
        
        assert response.status_code == 200
        data = response.json()
        
        assert len(data['results']) >= 1
        assert any('Property 01' in r['name'] for r in data['results'])
    
    def test_search_by_address(self, client, staff_user, sample_properties):
        """Should filter properties by address."""
        client.force_login(staff_user)
        url = reverse('property-search')
        
        response = client.get(url, {'q': '1 Test Street'})
        
        assert response.status_code == 200
        data = response.json()
        
        assert len(data['results']) >= 1
        assert any('1 Test Street' in (r.get('address') or '') or '1' in r['name'] for r in data['results'])
    
    def test_case_insensitive_search(self, client, staff_user, sample_properties):
        """Search should be case-insensitive."""
        client.force_login(staff_user)
        url = reverse('property-search')
        
        response = client.get(url, {'q': 'property 01'})
        
        assert response.status_code == 200
        data = response.json()
        
        assert len(data['results']) >= 1
    
    def test_pagination(self, client, staff_user, sample_properties):
        """Should support pagination."""
        client.force_login(staff_user)
        url = reverse('property-search')
        
        # Page 1
        response1 = client.get(url, {'page': 1, 'page_size': 10})
        data1 = response1.json()
        
        assert len(data1['results']) == 10
        assert data1['has_more'] is True
        assert data1['page'] == 1
        
        # Page 2
        response2 = client.get(url, {'page': 2, 'page_size': 10})
        data2 = response2.json()
        
        assert len(data2['results']) == 10
        assert data2['has_more'] is True
        
        # Results should be different
        ids1 = {r['id'] for r in data1['results']}
        ids2 = {r['id'] for r in data2['results']}
        assert ids1.isdisjoint(ids2)
    
    def test_last_page(self, client, staff_user, sample_properties):
        """Should indicate when no more results."""
        client.force_login(staff_user)
        url = reverse('property-search')
        
        # Get last page
        response = client.get(url, {'page': 3, 'page_size': 10})
        data = response.json()
        
        assert len(data['results']) == 10
        assert data['has_more'] is False
    
    def test_custom_page_size(self, client, staff_user, sample_properties):
        """Should respect custom page size."""
        client.force_login(staff_user)
        url = reverse('property-search')
        
        response = client.get(url, {'page_size': 5})
        data = response.json()
        
        assert len(data['results']) == 5
    
    def test_page_size_cap(self, client, staff_user, sample_properties):
        """Should cap page size at maximum."""
        client.force_login(staff_user)
        url = reverse('property-search')
        
        # Request 100, should get max 50
        response = client.get(url, {'page_size': 100})
        data = response.json()
        
        assert len(data['results']) <= 50
    
    def test_no_deleted_properties(self, client, staff_user, sample_properties):
        """Should exclude deleted properties."""
        client.force_login(staff_user)
        url = reverse('property-search')
        
        response = client.get(url, {'q': 'Deleted'})
        data = response.json()
        
        assert data['total'] == 0
        assert len(data['results']) == 0
    
    def test_ordered_results(self, client, staff_user, sample_properties):
        """Results should be ordered by name."""
        client.force_login(staff_user)
        url = reverse('property-search')
        
        response = client.get(url)
        data = response.json()
        
        names = [r['name'] for r in data['results']]
        assert names == sorted(names)
    
    def test_result_format(self, client, staff_user, sample_properties):
        """Should return properly formatted results."""
        client.force_login(staff_user)
        url = reverse('property-search')
        
        response = client.get(url)
        data = response.json()
        
        for result in data['results']:
            assert 'id' in result
            assert 'name' in result
            assert 'display' in result
    
    def test_empty_search_results(self, client, staff_user, sample_properties):
        """Should handle no results gracefully."""
        client.force_login(staff_user)
        url = reverse('property-search')
        
        response = client.get(url, {'q': 'NONEXISTENT'})
        data = response.json()
        
        assert response.status_code == 200
        assert data['total'] == 0
        assert len(data['results']) == 0
        assert data['has_more'] is False


@pytest.mark.django_db
class TestPropertyAutocompleteIntegration:
    """Integration tests for property autocomplete in forms."""
    
    def test_property_search_api_works(self, client, staff_user, sample_properties):
        """Property search API should work for autocomplete dropdowns."""
        client.force_login(staff_user)
        url = reverse('property-search')
        
        response = client.get(url)
        
        assert response.status_code == 200
        data = response.json()
        assert 'results' in data
        assert 'has_more' in data
        assert 'total' in data
        assert data['total'] == 30  # Our sample properties
        assert len(data['results']) <= 20  # Page size
    
    def test_autocomplete_with_search_query(self, client, staff_user, sample_properties):
        """Property search API should filter results by query."""
        client.force_login(staff_user)
        url = reverse('property-search')
        
        response = client.get(url, {'q': 'Property 01'})
        
        # Verify the API works with search
        assert response.status_code == 200
        data = response.json()
        assert 'results' in data
        assert len(data['results']) > 0
        # Results should match the query
        assert any('Property 01' in r['name'] for r in data['results'])


@pytest.mark.django_db  
class TestPropertySearchPerformance:
    """Performance tests for property search."""
    
    def test_large_dataset(self, client, staff_user, db):
        """Should handle large number of properties."""
        # Create 200 properties
        for i in range(200):
            Property.objects.create(
                name=f"Property {i+1:03d}",
                is_deleted=False
            )
        
        client.force_login(staff_user)
        url = reverse('property-search')
        
        import time
        start = time.time()
        response = client.get(url)
        duration = time.time() - start
        
        assert response.status_code == 200
        assert duration < 1.0  # Should respond within 1 second
        
        data = response.json()
        assert data['total'] == 200
        assert len(data['results']) == 20  # First page
    
    def test_complex_search(self, client, staff_user, sample_properties):
        """Should handle complex search queries efficiently."""
        client.force_login(staff_user)
        url = reverse('property-search')
        
        import time
        start = time.time()
        response = client.get(url, {'q': 'Property 0'})  # Matches many
        duration = time.time() - start
        
        assert response.status_code == 200
        assert duration < 0.5  # Fast search
