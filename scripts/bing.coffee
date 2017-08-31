
# Description:
#   Queries Bing and returns a random image from the top 50 images found using Bing API
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_BING_ACCOUNT_KEY
#
# Commands:
#   bing image <query> - Queries Bing Images for <query> & returns a random result from top 50
#
# Author:
#   Brandon Satrom

bingAccountKey = process.env.HUBOT_BING_ACCOUNT_KEY
unless bingAccountKey
  throw "You must set HUBOT_BING_ACCOUNT_KEY in your environment vairables"

module.exports = (robot) ->
  robot.hear /^bing( image)? (.*)/i, (msg) ->
    imageMe msg, msg.match[2], (url) ->
      time = Date.now()
      msg.send url + "?#{time}"

imageMe = (msg, query, cb) ->
  msg.http('https://api.cognitive.microsoft.com/bing/v5.0/images/search')
    .header("Ocp-Apim-Subscription-Key", "#{bingAccountKey}")
    .query(q: "'" + query + "'", $count: 20)
    .get() (err, res, body) ->
      try
        images = JSON.parse(body).value
        image = msg.random images
        cb image.contentUrl
      catch error
        cb body
