# README

* Configuration
`database.yml`
`freegoip.yml`

* Database creation
`bundle exec rake db:create db:migrate`

* How to run the test suite
`bundle exec rspec`

* Env requirements
`postgresql` `redis` 

* Env variables (if you do not change `database.yml/freegeoip.yml`
`FREEGEOIP_API_KEY` - freegoip (ipstack) api key
`DB_USERNAME` - database username
`DB_PASSWORD` - database password
`REDIS_URL` - redis url (format: redis://localhost:6379)

* Deployment instructions
`bundle install`
`rails s -b <binding> -p <port>` - start in dev mode

* Test task caveats
  * JWT token is not production ready since it's based on incremental id and secret only (basically knowing the secret would let one login to all users)
  * Mostly setup for running in dev mode
  * There is no CRON setup for delayed geolocation to retry them (DelayedGeolocationEnqueuerWorker).
  * There is no associations user <-> geolocation, wasn't sure about the "intention" behind the task. 
    * If the idea was for every user to be able to have his own list, a HMT association would be good.
    * For a "shared resource" a free for all (everyone can delete "anyones" geolocations) might be good enough.
  * There is no pagination on geolocation index which would be necessary in prod. (some filtering most likely aswell)
  * Spec coverage could be better
  * Invalid token specs should be moved to shared_specs
  * All commits/pushes were done to master which i would never do on production but
  for a test app i consider it acceptable.
  * Caching could be done much more efficiently (moved before finding the model to not require any DB interaction if cache_key is found)
  * Cache invalidation is not implemented (cache expiration changed to inefficient 3 minutes because of that, as there is no invalidation on update, geolocation is cached only when resolution is found).
