# Description:
#   Returns the latest news headlines from Google
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot news - Get the latest headlines
#   hubot news <topic> - Get the latest headlines for a specific topic
#
# Author:
#   Matt McCormick

bingAccountKey = process.env.HUBOT_BING_ACCOUNT_KEY
unless bingAccountKey
  throw "You must set HUBOT_BING_ACCOUNT_KEY in your environment vairables"

module.exports = (robot) ->
  robot.hear /^news (.*)/i, (msg) ->
    newsMe msg, msg.match[1], (newses) ->
      messages = ""
      for message in newses
        messages += "#{message.Title}\nlink: #{message.Url}\n\n"
      msg.reply 
        type: "text"
        contents: ["#{messages}"]

newsMe = (msg, query, cb) ->
  msg.http('https://api.datamarket.azure.com/Bing/Search/v1/News')
    .header("Authorization", "Basic " + new Buffer("#{bingAccountKey}:#{bingAccountKey}").toString('base64'))
    .query(Query: "'" + query + "'", Market: "'" + "ja-JP" + "'", $format: "json", $top: 5)
    .get() (err, res, body) ->
      try
        newses = JSON.parse(body).d.results
        cb newses
      catch error
        cb body
