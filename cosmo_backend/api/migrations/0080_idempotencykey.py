# Generated migration for IdempotencyKey model

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('api', '0079_booking_booking_no_overlap_active'),
    ]

    operations = [
        migrations.CreateModel(
            name='IdempotencyKey',
            fields=[
                ('key', models.CharField(
                    help_text='UUID idempotency key from client',
                    max_length=64,
                    primary_key=True,
                    serialize=False,
                    unique=True
                )),
                ('endpoint', models.CharField(
                    help_text='API endpoint path',
                    max_length=255
                )),
                ('method', models.CharField(
                    help_text='HTTP method (POST, PATCH, PUT, DELETE)',
                    max_length=10
                )),
                ('response_status', models.PositiveSmallIntegerField(
                    help_text='HTTP response status code'
                )),
                ('response_body', models.JSONField(
                    default=dict,
                    help_text='Cached response body'
                )),
                ('created_at', models.DateTimeField(
                    auto_now_add=True,
                    help_text='When the key was first processed'
                )),
                ('user', models.ForeignKey(
                    help_text='User who made the request',
                    on_delete=django.db.models.deletion.CASCADE,
                    related_name='idempotency_keys',
                    to=settings.AUTH_USER_MODEL
                )),
            ],
            options={
                'verbose_name': 'Idempotency Key',
                'verbose_name_plural': 'Idempotency Keys',
            },
        ),
        migrations.AddIndex(
            model_name='idempotencykey',
            index=models.Index(
                fields=['user', 'created_at'],
                name='api_idempot_user_id_a1b2c3_idx'
            ),
        ),
        migrations.AddIndex(
            model_name='idempotencykey',
            index=models.Index(
                fields=['created_at'],
                name='api_idempot_created_d4e5f6_idx'
            ),
        ),
    ]
