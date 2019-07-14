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

* Deployment instructions
`bundle install`
`rails s -b <binding> -p <port>` - start in dev mode
