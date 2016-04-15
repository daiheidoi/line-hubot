#/bin/sh

/usr/local/bin/curl -n -X PATCH https://api.heroku.com/apps/linebot-hubot/formation/worker \
-H "Accept: application/vnd.heroku+json; version=3" \
-H "Content-Type: application/json" \
-d '{ "quantity": 0 }'