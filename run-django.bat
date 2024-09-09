REM Start Django development server
start "" /B python manage.py runserver 0.0.0.0:8000

REM Start Django Q cluster
start "" /B python manage.py qcluster