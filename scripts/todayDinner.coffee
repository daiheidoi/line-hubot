# Description:
#   Today's dinner is thinking recipe using Rakuten API
#
# Dependencies:
#   request
#   underscore
#
# Configuration:
#   HUBOT_LINE_RAKUTEN_APPLICATION_ID
#
# Commands:
#   /(?:今日は|きょうは|、)?(.+)(?:かな)/
#
# Author:

{LineRawMessageListener, LineImageListener, LineVideoListener, LineAudioListener, LineLocationListener,
LineStickerListener, LineContactListener, LineRawOperationListener, LineFriendListener, LineBlockListener,
LineTextAction, LineImageAction, LineVideoAction, LineAudioAction, LineLocationAction, LineStickerAction
} = require 'hubot-line'

request = require 'request'
_ = require 'underscore';

applicationId = process.env.HUBOT_LINE_RAKUTEN_APPLICATION_ID

categoryEndpoint = "/services/api/Recipe/CategoryList/20121121?format=json&formatVersion=2&elements=categoryName%2CcategoryId%2CparentCategoryId&categoryType=medium&applicationId=#{applicationId}"
recipeEndpoint = (categoryId) -> "/services/api/Recipe/CategoryRanking/20121121?format=json&formatVersion=2&categoryId=#{categoryId}&applicationId=#{applicationId}"

categoryMap = {}

module.exports = (robot) ->
  createCategoryMap()

  robot.respond /(?:今日は|きょうは|、)?(.+)(?:かな)/, (msg) ->
    foodName = msg.match[1]

    if foodName?.match(/(何|なん)でもいい/)
      categoryId = categoryMap[_.sample(Object.keys(categoryMap))]
      callRecipeServiceApi recipeEndpoint(categoryId), (results) ->
        recipe = _.sample(results)
        msg.reply recommendRecipe(foodName, "なら", recipe)

    else if categoryMap[foodName]?
      categoryId = categoryMap[foodName]
      callRecipeServiceApi recipeEndpoint(categoryId), (results) ->
        recipe = _.sample(results)
        msg.reply recommendRecipe(foodName, "だと", recipe)
    else
      msg.reply 
        type: "text"
        contents: ["#{foodName}だとわからないからもうちょっと詳しく教えて"]

createCategoryMap = ->
  callRecipeServiceApi categoryEndpoint, (results) ->
    for cat in results.medium
      categoryMap[cat.categoryName] = "#{cat.parentCategoryId}-#{cat.categoryId}"

callRecipeServiceApi = (apiPath, callback) ->
  request.get { uri: "https://app.rakuten.co.jp" + apiPath, json: true }, (error, response, body) ->
    if error or response.statusCode != 200
      console.error(body)
      throw error
    return callback(body.result)

recommendRecipe = (foodName, phrase, recipe)->
    type: "text"
    contents: ["#{foodName}#{phrase}、#{recipe.recipeTitle} とかはどう？\n#{recipe.recipeUrl}"]