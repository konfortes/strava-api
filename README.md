# Strava API

## System Dependencies

* devise
* omniauth
* omniauth-strava
* postgres
* redis

### Database creation
```bash
create role stravaapi with createdb login password 'stravaapi';
rake db:create
```

### Database initialization
```bash
rake db:migrate
```

### External authorization
[http://localhost:3000/users/auth/strava](http://localhost:3000/users/auth/strava)

## Docker
```bash
docker-compose up --build
docker-compose exec website rails db:create
docker-compose exec website rails db:migrate
```
