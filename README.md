# Strava API

## System Dependencies

* devise
* omniauth
* omniauth-strava
* postgres
* redis

### Database creation

```bash
psql create role stravaapi with createdb login password 'stravaapi';
rake db:create
```

### External authorization

[http://localhost:3000/users/auth/strava](http://localhost:3000/users/auth/strava)  
make sure `STRAVA_CLIENT_ID` and `STRAVA_API_KEY` are being set in env (can use .env)  
If browsed from browser, a Devise auth cookie will be sent back.

## Docker

```bash
docker-compose up --build
```
