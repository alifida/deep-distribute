REM Start Django development server
start "" /B python manage.py runserver 0.0.0.0:89

REM Start Django Q cluster
start "" /B python manage.py qcluster