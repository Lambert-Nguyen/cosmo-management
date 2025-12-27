from __future__ import annotations

from typing import Any

from django import template

register = template.Library()


@register.filter
def get_item(mapping: Any, key: Any):
    """Template helper to safely read values from a dict.

    Returns an empty list if the key doesn't exist. This default plays nicely
    with `{% for %}` loops and `{% if not value %}` checks.
    """

    if not isinstance(mapping, dict):
        return []

    if key in mapping:
        return mapping[key]

    # Django templates sometimes pass numbers as strings.
    try:
        int_key = int(key)
    except (TypeError, ValueError):
        return []

    return mapping.get(int_key, [])
