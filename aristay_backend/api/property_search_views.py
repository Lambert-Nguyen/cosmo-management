"""
Property search views for autocomplete functionality in forms.

Provides lightweight AJAX endpoints for property searching with pagination
and filtering to improve performance with large property datasets.
"""

from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from django.db.models import Q
from .models import Property


@login_required
def property_search(request):
    """
    Search for properties by name with pagination.
    
    Used for autocomplete dropdowns in task forms and other interfaces
    where property selection is needed.
    
    Query Parameters:
        q (str): Search query (searches name and address)
        page (int): Page number for pagination (default: 1)
        page_size (int): Results per page (default: 20, max: 50)
        
    Returns:
        JSON response with:
        - results: List of {id, name, display} objects
        - has_more: Boolean indicating if more results exist
        - total: Total number of matching properties
    """
    query = request.GET.get('q', '').strip()
    page = int(request.GET.get('page', 1))
    page_size = min(int(request.GET.get('page_size', 20)), 50)  # Cap at 50
    
    # Base queryset - only active properties
    properties = Property.objects.filter(is_deleted=False)
    
    # Apply search filter if query provided
    if query:
        properties = properties.filter(
            Q(name__icontains=query) | Q(address__icontains=query)
        )
    
    # Order by name for consistent results
    properties = properties.order_by('name')
    
    # Get total count before pagination
    total = properties.count()
    
    # Calculate pagination
    start = (page - 1) * page_size
    end = start + page_size
    
    # Get paginated results
    page_properties = properties[start:end]
    
    # Format results
    results = [
        {
            'id': prop.id,
            'name': prop.name,
            'display': prop.name
        }
        for prop in page_properties
    ]
    
    # Check if more results exist
    has_more = end < total
    
    return JsonResponse({
        'results': results,
        'has_more': has_more,
        'total': total,
        'page': page,
        'page_size': page_size
    })
