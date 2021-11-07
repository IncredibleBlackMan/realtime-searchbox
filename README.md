# REALTIME SEARCHBOX

A realtime search box, where users search articles, and have analytics that display what users were searching for.

## Prerequisites
- Install `rvm` -> \curl -sSL https://get.rvm.io | bash
- Install `ruby` -> \curl -sSL https://get.rvm.io | bash -s stable --ruby
- Install `Postgres` ->
- Install Elastic search -> https://www.elastic.co/guide/en/elasticsearch/reference/current/brew.html

## Setup

1. Clone this repository `git clone https://github.com/IncredibleBlackMan/realtime-searchbox.git`
2. Go into the directory of the repo
3. Run `bundle install`
4. Run `cp config/database.yml.example config/database.yml`, setup `username` and `password`

* Database creation and configuration

```
rake db:create
rake db:migrate
rake db:seed

rake db:create:analytics
rake db:migrate:analytics
```

5. Run server

## Hosted site
https://realtime-searchbox-helpjuice.herokuapp.com/

- Login credentials
```
email: example1@helpjuice.com
password: pass1234
```
