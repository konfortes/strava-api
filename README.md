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

This app uses [omniauth](https://github.com/omniauth/omniauth).  
Authorization initiated by browsing to [http://localhost:3000/users/auth/strava](http://localhost:3000/users/auth/strava).  
This endpoint will redirect you to `https://www.strava.com/oauth/authorize` with client_id, redirect_uri (`/users/auth/strava/callback`) and some other parameters.  
after authorizing with Strava, you will be redirected back to the specified `redirect_uri` and a user will be created (or signed in). The user contains `authorization_token` that will be used to call Strava api on behalf of the user.
  
make sure `STRAVA_CLIENT_ID` and `STRAVA_API_KEY` are being set in env (can use .env)  
If browsed from browser, a Devise auth cookie will be sent back.

## Docker

```bash
docker-compose up --build
```

### Postgis

```bash
brew install postgis
```

run migrations (`CREATE EXTENSION IF NOT EXISTS postgis`) and make sure the user is a SUPERUSER (consider `ALTER ROLE stravaapi SUPERUSER;`)
