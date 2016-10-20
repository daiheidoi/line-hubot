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
      # httpだとLINEAPI内で弾かれるため整形 してもダメだった
      msg.reply 
        type: "text"
        contents: ["#{newses[0]["Title"]}\nlink: #{newses[0].Url}\n\n#{newses[1].Title}\nlink: #{newses[1].Url}\n\n#{newses[2].Title}\nlink: #{newses[2].Url}\n\n#{newses[3].Title}\nlink: #{newses[3].Url}\n\n#{newses[4].Title}\nlink: #{newses[4].Url}"]

newsMe = (msg, query, cb) ->
  msg.http('https://api.datamarket.azure.com/Bing/Search/v1/News')
    .header("Authorization", "Basic " + new Buffer("#{bingAccountKey}:#{bingAccountKey}").toString('base64'))
    .query(Query: "'" + query + "'", Market: "'" + "ja-JP" + "'", $format: "json", $top: 5)
    .get() (err, res, body) ->
      try
        console.log(body)
        newses = JSON.parse(body).d.results
        console.log(newses)
        console.log(newses[0])
        cb newses
      catch error
        cb body
