from django import template
from datetime import timedelta

register = template.Library()

@register.filter
def date_diff(started_at, ended_at):
    if started_at and ended_at:
        difference = ended_at - started_at
        return difference
    return None
