"""
Global pytest configuration for Django integration.
Ensures Django is properly setup before test collection begins.
"""

import os
import sys
import pytest
from pathlib import Path

# Get the absolute path to the project root
PROJECT_ROOT = Path(__file__).parent.absolute()
BACKEND_DIR = PROJECT_ROOT / 'aristay_backend'

# Add the backend directory to Python path for imports
if str(BACKEND_DIR) not in sys.path:
    sys.path.insert(0, str(BACKEND_DIR))

# Set essential environment variables for testing
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings_test')
# Force simple staticfiles storage for all tests (avoid manifest lookups)
os.environ.setdefault('STATICFILES_STORAGE', 'django.contrib.staticfiles.storage.StaticFilesStorage')
os.environ.setdefault('DJANGO_ENVIRONMENT', 'testing')
os.environ.setdefault('TESTING', 'true')
os.environ.setdefault('USE_CLOUDINARY', 'false')
os.environ.setdefault('DATABASE_URL', '')
os.environ.setdefault('LOAD_DOTENV', 'false')

# Ensure minimal configuration for Django setup
try:
    # Import and setup Django before any tests run
    import django
    from django.conf import settings
    
    # Setup Django if not already configured
    if not settings.configured:
        django.setup()
    
    # Verify Django is working by checking if apps are populated
    from django.apps import apps
    if not apps.ready:
        django.setup()

    # ---------------------------------------------------------------------
    # Compatibility shim: Django template context copying on Python 3.13
    #
    # Django's BaseContext.__copy__ in 5.1.x calls copy(super()), which can
    # trigger a RecursionError under Python 3.13 when the Django test client
    # copies template contexts (template_rendered signal).
    #
    # We patch BaseContext.__copy__ for tests only to avoid recursion while
    # preserving the expected shallow-copy semantics.
    # ---------------------------------------------------------------------
    if sys.version_info >= (3, 13):
        try:
            from django.template.context import BaseContext

            def _basecontext_copy_py313(self):
                duplicate = self.__class__.__new__(self.__class__)
                duplicate.__dict__.update(self.__dict__)
                duplicate.dicts = self.dicts[:]
                return duplicate

            BaseContext.__copy__ = _basecontext_copy_py313
        except Exception as _patch_exc:
            print(f"Warning: Could not apply BaseContext.__copy__ shim: {_patch_exc}")
    
except Exception as e:
    print(f"Warning: Django setup issue in conftest.py: {e}")
    # Continue anyway - individual tests can handle setup if needed

@pytest.fixture(autouse=True)
def _enable_db_access_for_all_tests(db):
    """Give every test DB access by default."""
    pass

@pytest.fixture(scope='session')
def teststaff_user(django_db_setup, django_db_blocker):
    """Create teststaff user for tests that need it"""
    with django_db_blocker.unblock():
        try:
            from django.contrib.auth.models import User
            from api.models import Profile, UserRole
            
            # Create or get teststaff user
            user, created = User.objects.get_or_create(
                username='teststaff',
                defaults={
                    'email': 'teststaff@example.com',
                    'first_name': 'Test',
                    'last_name': 'Staff',
                    'is_active': True,
                    'is_staff': True,  # Django staff for admin access
                }
            )
            
            # Set password
            user.set_password('testpass123')
            user.save()
            
            # Create or get profile with MANAGER role (since tests expect manager permissions)
            profile, _ = Profile.objects.get_or_create(
                user=user,
                defaults={'role': UserRole.MANAGER}
            )
            
            return user
        except ImportError as e:
            print(f"Warning: Could not import models for teststaff_user: {e}")
            return None
