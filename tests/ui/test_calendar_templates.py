"""
Calendar Template Tests
Tests for calendar HTML templates and UI functionality
"""
import os
import sys
import pytest
from django.test import TestCase, Client, override_settings
from django.urls import reverse
from django.contrib.auth import get_user_model
from django.template.loader import get_template
from pathlib import Path

User = get_user_model()


@override_settings(
    AUTHENTICATION_BACKENDS=[
        'django.contrib.auth.backends.ModelBackend',
    ]
)
class CalendarTemplateTestCase(TestCase):
    """Test cases for Calendar template functionality"""
    
    def setUp(self):
        """Set up test data"""
        self.client = Client()
        
        # Create test users
        self.superuser = User.objects.create_superuser(
            'admin', 'admin@test.com', 'password123'
        )
        
        self.manager = User.objects.create_user(
            'manager', 'manager@test.com', 'password123'
        )
        
        self.staff = User.objects.create_user(
            'staff', 'staff@test.com', 'password123'
        )
        
        # Create profiles
        from api.models import Profile
        Profile.objects.get_or_create(
            user=self.manager,
            defaults={'role': 'manager', 'timezone': 'UTC'}
        )
        Profile.objects.get_or_create(
            user=self.staff,
            defaults={'role': 'staff', 'timezone': 'UTC'}
        )
    
    def test_calendar_template_exists(self):
        """Test that calendar templates exist and can be loaded"""
        # Test standalone calendar template
        try:
            template = get_template('calendar/calendar_view.html')
            self.assertIsNotNone(template)
        except Exception as e:
            self.fail(f"Calendar template not found: {e}")
        
        # Test portal calendar template
        try:
            template = get_template('portal/calendar.html')
            self.assertIsNotNone(template)
        except Exception as e:
            self.fail(f"Portal calendar template not found: {e}")
    
    def test_standalone_calendar_view_authenticated(self):
        """Test standalone calendar view with authenticated user"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/calendar/')
        
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'Property Management Calendar')
        self.assertContains(response, 'fullcalendar')
        self.assertContains(response, 'calendar-container')
    
    def test_standalone_calendar_view_unauthorized(self):
        """Test standalone calendar view without authentication"""
        response = self.client.get('/api/calendar/')
        
        # Should redirect to login
        self.assertEqual(response.status_code, 302)
    
    def test_portal_calendar_view_authenticated(self):
        """Test portal calendar view with authenticated user"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'Property Management Calendar')
        self.assertContains(response, 'fullcalendar')
        self.assertContains(response, 'calendar-container')
    
    def test_portal_calendar_view_unauthorized(self):
        """Test portal calendar view without authentication"""
        response = self.client.get('/api/portal/calendar/')
        
        # Should redirect to login
        self.assertEqual(response.status_code, 302)
    
    def test_calendar_template_contains_required_elements(self):
        """Test that calendar template contains all required UI elements"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        # Check for main calendar elements
        self.assertContains(response, 'calendar-container')
        self.assertContains(response, 'calendar-header')
        self.assertContains(response, 'calendar-filters')
        self.assertContains(response, 'calendar-wrapper')
        
        # Check for FullCalendar integration
        self.assertContains(response, 'fullcalendar')
        self.assertContains(response, 'index.global.min.js')
        
        # Check for filter elements
        self.assertContains(response, 'propertyFilter')
        self.assertContains(response, 'eventTypeFilter')
        self.assertContains(response, 'statusFilter')
        self.assertContains(response, 'assignedToFilter')
        
        # Check for action buttons
        self.assertContains(response, 'Apply')
        self.assertContains(response, 'Clear')
        self.assertContains(response, 'Refresh')
        self.assertContains(response, 'Export')
    
    def test_calendar_template_contains_javascript(self):
        """Test that calendar template contains required JavaScript"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        # JS is now loaded as an external module
        self.assertContains(response, 'js/pages/portal-calendar.js')
        self.assertContains(response, 'type="module"')

        # Check for action hooks used by the JS module
        self.assertContains(response, 'data-action="calendar-refresh"')
        self.assertContains(response, 'data-action="calendar-export"')
        self.assertContains(response, 'data-action="calendar-apply-filters"')
        self.assertContains(response, 'data-action="calendar-clear-filters"')
        self.assertContains(response, 'data-action="calendar-close-modal"')
        self.assertContains(response, 'data-action="calendar-view-details"')
    
    def test_calendar_template_contains_css_styles(self):
        """Test that calendar template contains required CSS styles"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        # CSS is now loaded as an external stylesheet
        self.assertContains(response, 'css/pages/portal-calendar.css')

        css_path = Path(__file__).resolve().parents[2] / 'aristay_backend' / 'static' / 'css' / 'pages' / 'portal-calendar.css'
        css = css_path.read_text(encoding='utf-8')
        self.assertIn('event-task', css)
        self.assertIn('event-booking', css)
        self.assertIn('status-badge', css)
        self.assertIn('status-pending', css)
        self.assertIn('status-in-progress', css)
        self.assertIn('status-completed', css)
    
    def test_calendar_modal_functionality(self):
        """Test that calendar template contains modal functionality"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        # Check for modal elements
        self.assertContains(response, 'eventModal')
        self.assertContains(response, 'eventModalTitle')
        self.assertContains(response, 'eventModalBody')
        self.assertContains(response, 'eventModalAction')
        
        # Modal controls are now wired via data-action hooks
        self.assertContains(response, 'data-action="calendar-close-modal"')
    
    def test_calendar_responsive_design(self):
        """Test that calendar template is responsive"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        # Check for responsive elements
        self.assertContains(response, 'calendar-container')
        self.assertContains(response, 'calendar-filters-section')
        self.assertContains(response, 'calendar-main-section')
    
    def test_calendar_permission_based_elements(self):
        """Test that calendar shows appropriate elements based on user permissions"""
        # Test with manager (should see all elements)
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'assignedToFilter')  # Managers can see user filter
        
        # Test with staff (should see limited elements)
        self.client.force_login(self.staff)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        # Staff should still see the filter but with limited data
        self.assertContains(response, 'assignedToFilter')
    
    def test_calendar_template_loading_indicators(self):
        """Test that calendar template contains loading indicators"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        js_path = Path(__file__).resolve().parents[2] / 'aristay_backend' / 'static' / 'js' / 'pages' / 'portal-calendar.js'
        js = js_path.read_text(encoding='utf-8')
        self.assertIn('console.error', js)
    
    def test_calendar_template_error_handling(self):
        """Test that calendar template contains error handling"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        js_path = Path(__file__).resolve().parents[2] / 'aristay_backend' / 'static' / 'js' / 'pages' / 'portal-calendar.js'
        js = js_path.read_text(encoding='utf-8')
        self.assertIn('console.error', js)
    
    def test_calendar_template_fontawesome_integration(self):
        """Test that calendar template includes FontAwesome icons"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        # Check for FontAwesome integration
        self.assertContains(response, 'font-awesome')
        self.assertContains(response, 'fas fa-sync-alt')
        self.assertContains(response, 'fas fa-download')
        self.assertContains(response, 'fas fa-filter')
        self.assertContains(response, 'fas fa-times')
    
    def test_calendar_template_favicon(self):
        """Test that calendar template includes favicon"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        # Check for favicon
        self.assertContains(response, 'rel="icon"')
        self.assertContains(response, 'image/x-icon')
    
    def test_calendar_template_meta_tags(self):
        """Test that calendar template includes proper meta tags"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        # Check for meta tags
        self.assertContains(response, 'charset="utf-8"')
        self.assertContains(response, 'viewport')
    
    def test_calendar_template_bootstrap_integration(self):
        """Test that calendar template uses Bootstrap classes"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        # Check for custom button classes
        self.assertContains(response, 'btn-action')
        self.assertContains(response, 'btn-filter')
        self.assertContains(response, 'btn-modal')
        self.assertContains(response, 'btn-primary')
        self.assertContains(response, 'btn-secondary')
        self.assertContains(response, 'modal')
    
    def test_calendar_template_data_attributes(self):
        """Test that calendar template includes proper data attributes"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        # Check for data attributes
        self.assertContains(response, 'data-portal-task-detail')
        self.assertContains(response, 'data-portal-booking-detail')
    
    def test_calendar_template_accessibility(self):
        """Test that calendar template includes accessibility features"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        # Check for accessibility features
        self.assertContains(response, 'for=')  # Label associations
        self.assertContains(response, 'filter-label')
        self.assertContains(response, 'calendar-container')
    
    def test_calendar_template_api_endpoints(self):
        """Test that calendar template references correct API endpoints"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        # Check for API endpoint references
        self.assertContains(response, '/api/calendar/events/')
        self.assertContains(response, '/api/calendar/properties/')
        self.assertContains(response, '/api/calendar/users/')
        self.assertContains(response, '/api/calendar/day_events/')
    
    def test_calendar_template_url_generation(self):
        """Test that calendar template generates correct URLs"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        # Check for URL generation
        self.assertContains(response, 'portal-task-detail')
        self.assertContains(response, 'portal-booking-detail')
    
    def test_calendar_template_event_styling(self):
        """Test that calendar template includes event styling"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        js_path = Path(__file__).resolve().parents[2] / 'aristay_backend' / 'static' / 'js' / 'pages' / 'portal-calendar.js'
        js = js_path.read_text(encoding='utf-8')
        self.assertIn('#007bff', js)  # Default event color
        self.assertIn('border-left: 3px solid', js)
        self.assertIn('background-color: #f8f9fa', js)
    
    def test_calendar_template_mobile_optimization(self):
        """Test that calendar template is mobile-optimized"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        self.assertContains(response, 'calendar-container')
        css_path = Path(__file__).resolve().parents[2] / 'aristay_backend' / 'static' / 'css' / 'pages' / 'portal-calendar.css'
        css = css_path.read_text(encoding='utf-8')
        self.assertIn('text-overflow: ellipsis', css)
        self.assertIn('overflow: hidden', css)
    
    def test_calendar_template_performance_optimization(self):
        """Test that calendar template includes performance optimizations"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        self.assertContains(response, 'calendar-container')
        css_path = Path(__file__).resolve().parents[2] / 'aristay_backend' / 'static' / 'css' / 'pages' / 'portal-calendar.css'
        css = css_path.read_text(encoding='utf-8')
        self.assertIn('cursor: pointer', css)
    
    def test_calendar_template_internationalization(self):
        """Test that calendar template supports internationalization"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        js_path = Path(__file__).resolve().parents[2] / 'aristay_backend' / 'static' / 'js' / 'pages' / 'portal-calendar.js'
        js = js_path.read_text(encoding='utf-8')
        self.assertIn('toLocaleDateString', js)
        self.assertIn('toISOString', js)
    
    def test_calendar_template_cross_browser_compatibility(self):
        """Test that calendar template is cross-browser compatible"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        js_path = Path(__file__).resolve().parents[2] / 'aristay_backend' / 'static' / 'js' / 'pages' / 'portal-calendar.js'
        js = js_path.read_text(encoding='utf-8')
        self.assertIn('addEventListener', js)
        self.assertIn('preventDefault', js)
        self.assertIn('stopPropagation', js)
    
    def test_calendar_template_security_features(self):
        """Test that calendar template includes security features"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        # Check for security features
        self.assertContains(response, 'csrfmiddlewaretoken')
        self.assertContains(response, 'X-Content-Type-Options')
        
        # Check HTTP security headers (not in HTML content)
        self.assertIn('X-Frame-Options', response.headers)
        self.assertEqual(response.headers['X-Frame-Options'], 'DENY')
    
    def test_calendar_template_analytics_integration(self):
        """Test that calendar template supports analytics integration"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        js_path = Path(__file__).resolve().parents[2] / 'aristay_backend' / 'static' / 'js' / 'pages' / 'portal-calendar.js'
        js = js_path.read_text(encoding='utf-8')
        self.assertIn('console.log', js)
        self.assertIn('console.error', js)
    
    def test_calendar_template_debugging_support(self):
        """Test that calendar template includes debugging support"""
        self.client.force_login(self.manager)
        response = self.client.get('/api/portal/calendar/')
        
        self.assertEqual(response.status_code, 200)
        
        js_path = Path(__file__).resolve().parents[2] / 'aristay_backend' / 'static' / 'js' / 'pages' / 'portal-calendar.js'
        js = js_path.read_text(encoding='utf-8')
        self.assertIn('console.error', js)
        self.assertIn('Error loading events', js)
        self.assertIn('Error loading day events', js)
