# README
* System dependencies
devise
omniauth
omniauth-strava

* Configuration

* Database creation
create role stravaapi with createdb login password 'stravaapi';
rake db:create

* Database initialization
rake db:migrate

* External authorization
http://localhost:3000/users/auth/strava
