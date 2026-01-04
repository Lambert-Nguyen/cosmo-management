# api/idempotency_middleware.py
"""
Idempotency middleware for offline sync replay deduplication.

This middleware intercepts requests with X-Idempotency-Key headers and ensures
that mutations are not duplicated when the client replays offline changes.

Usage:
- Client sends X-Idempotency-Key header with a UUID for each mutation
- If the key has been seen before, return the cached response
- If new, execute the request and cache the response with the key
"""

import json
import logging
from django.http import JsonResponse
from django.utils.deprecation import MiddlewareMixin

logger = logging.getLogger(__name__)

# HTTP methods that should be checked for idempotency
IDEMPOTENT_METHODS = {'POST', 'PATCH', 'PUT', 'DELETE'}

# API paths that support idempotency (task mutations)
IDEMPOTENT_PATHS = [
    '/api/tasks/',
    '/api/tasks',
]


class IdempotencyMiddleware(MiddlewareMixin):
    """
    Middleware to handle idempotency keys for offline sync deduplication.

    When a request includes an X-Idempotency-Key header:
    1. Check if this key has been processed before
    2. If yes, return the cached response (dedupe)
    3. If no, let the request proceed and cache the response
    """

    def _should_check_idempotency(self, request):
        """Determine if this request should be checked for idempotency."""
        # Only check mutating methods
        if request.method not in IDEMPOTENT_METHODS:
            return False

        # Only check API task paths
        if not any(request.path.startswith(p) for p in IDEMPOTENT_PATHS):
            return False

        # Must have the idempotency key header
        idempotency_key = request.META.get('HTTP_X_IDEMPOTENCY_KEY')
        if not idempotency_key:
            return False

        # User must be authenticated
        if not hasattr(request, 'user') or not request.user.is_authenticated:
            return False

        return True

    def process_request(self, request):
        """Check for duplicate request before processing."""
        if not self._should_check_idempotency(request):
            return None

        idempotency_key = request.META.get('HTTP_X_IDEMPOTENCY_KEY')

        # Import here to avoid circular imports
        from .models import IdempotencyKey

        try:
            # Check if this key already exists
            existing = IdempotencyKey.objects.filter(
                key=idempotency_key,
                user=request.user
            ).first()

            if existing:
                # Key exists - return cached response (dedupe)
                logger.info(
                    f"Idempotency dedupe: key={idempotency_key[:8]}... "
                    f"endpoint={existing.endpoint} user={request.user.username}"
                )
                return JsonResponse(
                    existing.response_body,
                    status=existing.response_status
                )
        except Exception as e:
            # Log but don't block request on idempotency check failure
            logger.error(f"Idempotency check failed: {e}")

        # Store key for later use in process_response
        request._idempotency_key = idempotency_key
        return None

    def process_response(self, request, response):
        """Cache response for idempotent requests."""
        idempotency_key = getattr(request, '_idempotency_key', None)

        if not idempotency_key:
            return response

        # Only cache successful responses (2xx status codes)
        if not (200 <= response.status_code < 300):
            return response

        # Import here to avoid circular imports
        from .models import IdempotencyKey

        try:
            # Parse response body
            if hasattr(response, 'content'):
                try:
                    response_body = json.loads(response.content.decode('utf-8'))
                except (json.JSONDecodeError, UnicodeDecodeError):
                    response_body = {}
            else:
                response_body = {}

            # Store the idempotency key with response
            IdempotencyKey.objects.create(
                key=idempotency_key,
                user=request.user,
                endpoint=request.path,
                method=request.method,
                response_status=response.status_code,
                response_body=response_body
            )

            logger.debug(
                f"Idempotency key stored: key={idempotency_key[:8]}... "
                f"endpoint={request.path} user={request.user.username}"
            )
        except Exception as e:
            # Log but don't fail the response
            logger.error(f"Failed to store idempotency key: {e}")

        return response
