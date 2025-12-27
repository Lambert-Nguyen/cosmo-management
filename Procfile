web: gunicorn backend.wsgi --chdir cosmo_backend --log-file - --bind 0.0.0.0:$PORT
release: python cosmo_backend/manage.py migrate