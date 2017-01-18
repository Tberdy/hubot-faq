# Description:
#   FAQ module for Hubot
#
# Commands:
#   hubot faq - List FAQ
#   hubot faq "name" - Display the FAQ and answer
#

Fs = require 'fs'
Path = require 'path'

readFAQ = ->
  faqPath = Path.resolve ".", "faq.json"
  if Fs.existsSync(faqPath)
    data = Fs.readFileSync(faqPath)
    if data.length > 0
      try
        faqDB = JSON.parse data
        faqDB
      catch err
        robot.logger.error "Error parsing JSON data from faq.json: #{err}"
  

module.exports = (robot) ->
  robot.respond /faq list/i, (msg) ->
    faqDB = readFAQ()
    msg.send faqDB.keys.join('\n')
      
      
  robot.respond /faq add "([a-zA-Z]+)" "(([a-zA-Z]+)"/i, (msg) ->
    text = msg.message.text
    if text.match(/apple/i) or text.match(/dev/i)
      msg.send otherRules.join('\n')
    else
      msg.send rules.join('\n')
      
      
      
  robot.respond /^faq ([a-zA-Z]+)/i, (msg) ->
    faqDB = readFAQ()
    faq = msg.match[1]
    faq.trim()
    if faqDB.hasOwnProperty faq
      msg.send faqDB[faq]
    else
      msg.send 'La FAQ n\'existe pas.'
