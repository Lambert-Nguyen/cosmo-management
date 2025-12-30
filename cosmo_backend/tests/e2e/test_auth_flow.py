import pytest
from django.urls import reverse
from django.contrib.auth import get_user_model

User = get_user_model()

@pytest.mark.django_db
class TestAuthFlow:
    def test_login_and_dashboard_access(self, client):
        # 1. Create User
        user = User.objects.create_user(username='e2e_user', password='password123')
        
        # 2. Login (Get Token)
        response = client.post('/api/token/', {'username': 'e2e_user', 'password': 'password123'})
        assert response.status_code == 200
        data = response.json()
        access_token = data['access']
        
        # 3. Access Protected Resource
        headers = {'HTTP_AUTHORIZATION': f'Bearer {access_token}'}
        
        # Use the 'current-user' endpoint
        response = client.get('/api/users/me/', **headers)
        
        assert response.status_code == 200
        data = response.json()
        assert data['username'] == 'e2e_user'
