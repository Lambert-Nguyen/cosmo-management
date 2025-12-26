import pytest
from django.urls import reverse
from django.contrib.auth import get_user_model

User = get_user_model()

@pytest.mark.django_db
class TestAuthFlow:
    def test_login_and_dashboard_access(self, client):
        # 1. Create User
        user = User.objects.create_user(username='e2e_user', password='password123')
        
        # 2. Login
        login_url = reverse('token_obtain_pair')  # Assuming JWT auth or standard login
        # If using standard django login:
        # login_success = client.login(username='e2e_user', password='password123')
        # assert login_success
        
        # Let's try to hit a protected endpoint
        # First, get token
        response = client.post('/api/token/', {'username': 'e2e_user', 'password': 'password123'})
        assert response.status_code == 200
        data = response.json()
        access_token = data['access']
        
        # 3. Access Protected Resource
        # Access user profile
        headers = {'HTTP_AUTHORIZATION': f'Bearer {access_token}'}
        
        # Use the 'current-user' endpoint we found in urls.py
        response = client.get('/api/users/me/', **headers)
        
        assert response.status_code == 200
        data = response.json()
        assert data['username'] == 'e2e_user'
        # assert 'email' in data # if email is returned
