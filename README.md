sfjourney
=========

A rails server to manage registrations for the Journey to the End of the Night

It is set up to use heroku, so stores secrets in environment variables (kept in .env, which is not checked in to the repo).  Environment variables required are:
SECRET_KEY_BASE
FACEBOOK_KEY
FACEBOOK_SECRET
GOOGLE_KEY
GOOGLE_SECRET
GMAIL_EMAIL
GMAIL_DOMAIN
GMAIL_PASSWORD
AUTHORIZED_USERS

You can create a sample .env file by copying the env.sample file to .env.

To run using the same method as will be run on heroku (including environment settings), run:
```
DATABASE_URL=postgres://localhost/sfjourney_development RACK_ENV=development PORT=3000 foreman start
```

To log in in development, the easiest way is to create an OpenID at http://openid.yahoo.com/ and use that to log in

To load up seed data
```
rake db:seed
```
(or to overwrite the seed data using the current db data, RAILS4=true WITHOUT_PROTECTION=false rake db:seed:dump)

To download a backup of the DB and import it locally:
```
heroku pgbackups:capture
curl -o latest.dump `heroku pg:backups public-url`
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U `whoami` -d sfjourney_development latest.dump
rake db:migrate
pg_restore latest.dump > latest.sql
```

To deploy to heroku
===================
```
git add remote heroku git@heroku.com:sfjourney.git
git push heroku master
heroku run rake db:migrate
```