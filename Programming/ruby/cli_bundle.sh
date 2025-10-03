#!/bin/zsh
exit 0
# --------------------------------------------------

### (同 npm install)
bundle install

### 列出 Api Endpoints
bundle exec rails routes

### Run Server
bundle exec rails server

### 進入互動式介面
bundle exec rails console

###
bundle exec rails db:migrate
bundle exec rails db:migrate:status