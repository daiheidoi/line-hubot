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

{LineImageAction} = require 'hubot-line'

bingAccountKey = process.env.HUBOT_BING_ACCOUNT_KEY
unless bingAccountKey
  throw "You must set HUBOT_BING_ACCOUNT_KEY in your environment vairables"

module.exports = (robot) ->
  robot.hear /^bing( image)? (.*)/i, (msg) ->
    imageMe msg, msg.match[2], (url) ->
      # httpだとLINEAPI内で弾かれるため整形 してもダメだった
      httpsUrls = ""
      if url[0..4] is "https" then httpsUrls = url else httpsUrls = url.replace(/http/, "https")
      console.log "httpsUrls: #{httpsUrls}"
      msg.reply 
        type: "image"
        contents: [
          original: "#{httpsUrls}"
          preview: "#{httpsUrls}"
          ]

imageMe = (msg, query, cb) ->
  msg.http('https://api.datamarket.azure.com/Bing/Search/Image')
    .header("Authorization", "Basic " + new Buffer("#{bingAccountKey}:#{bingAccountKey}").toString('base64'))
    .query(Query: "'" + query + "'", $format: "json", $top: 50)
    .get() (err, res, body) ->
      try
        images = JSON.parse(body).d.results
        image = msg.random images
        cb image.MediaUrl
      catch error
        cb body