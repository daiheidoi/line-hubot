# Description:
#   Returns 美人
#
#
# Commands:
#   hubot bijin - 美人を返します
#
# Author:
#   

{LineImageAction} = require 'hubot-line'

module.exports = (robot) ->
  robot.respond /美人/i, (msg) ->
    msg
      .http('http://bjin.me/api/?type=rand&count=1&format=json')
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        if err
          msg.send('美人の取得に失敗しました')
          return
        result = JSON.parse(body)
        category = result[0].category
        thumb = result[0].thumb
        link = result[0].link
        msg.send "お名前: #{category}\n" +
        msg.emote new LineImageAction link, link