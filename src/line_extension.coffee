{Adapter, TextMessage} = require 'hubot'
request = require 'request'
lineDefaultEP = 'https://trialbot-api.line.me/v1/events'

require 'hubot-line-trial' 

class LineExtension extends Line
  sendImg: (envelope, strings...) ->
    data = JSON.stringify({
      "to": [envelope.user.name],
      "toChannel": 1383378250,
      "eventType": "138311608800106203",
      "content":{
        "contentType": 2,
        "toType": 1,
        "originalContentUrl": strings.join('\n'),
        "previewImageUrl": strings.join('\n')
      }
    })
    console.log(data)
    # using request module to use FIXIE PROXY
    proxyopt = {}
    proxyopt = {'proxy': process.env.FIXIE_URL} if process.env.FIXIE_URL
    customRequest = request.defaults(proxyopt)
    customRequest.post
      url: @lineEndpoint,
      headers: {
        'X-Line-ChannelID': @channelId,
        'X-Line-ChannelSecret': @channelSecret,
        'X-Line-Trusted-User-With-ACL': @channelMid,
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: data
    , (err, response, body) ->
      throw err if err
      if response.statusCode is 200
        console.log "success"
        console.log body
      else
        console.log "response error: #{response.statusCode}"
        console.log body

module.exports.use = (robot) ->
  new LineExtension(robot)