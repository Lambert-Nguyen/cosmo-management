.PHONY: setup run shell migrate test validate

VENV := .venv
PY := $(VENV)/bin/python
PIP := $(VENV)/bin/pip

setup:
	python3 -m venv $(VENV)
	$(PIP) install --upgrade pip
	$(PIP) install -r cosmo_backend/requirements.txt

run:
	cd cosmo_backend && $(CURDIR)/$(PY) manage.py runserver 0.0.0.0:8000

shell:
	cd cosmo_backend && $(CURDIR)/$(PY) manage.py shell

migrate:
	cd cosmo_backend && $(CURDIR)/$(PY) manage.py makemigrations
	cd cosmo_backend && $(CURDIR)/$(PY) manage.py migrate

test:
	cd cosmo_backend && $(CURDIR)/$(PY) -m pytest -q

validate:
	cd cosmo_backend && $(CURDIR)/$(PY) validate_audit_system.py

dev-server:
	cd cosmo_backend && $(CURDIR)/$(PY) manage.py runserver 0.0.0.0:8001
