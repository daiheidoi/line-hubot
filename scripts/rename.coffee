# Description:
#   Tell people hubot's new name if they use the old one
#
# Commands:
#   None
#
# module.exports = (robot) ->
#   robot.hear /^hubot:? (.+)/i, (res) ->
#     response = "Sorry, I'm a diva and only respond to #{robot.name}"
#     response += " or #{process.env.HUBOT_LINE_BOTNAME}" if process.env.HUBOT_LINE_BOTNAME
#     res.reply response
#     return