# Description:
#   FAQ module for Hubot
#
# Commands:
#   hubot faq - List FAQ
#   hubot faq "name" - Display the FAQ and answer
#

Fs = require 'fs'
Path = require 'path'

faqPath = Path.resolve ".", "faq.json"
  
readFAQ = () ->
  if Fs.existsSync(faqPath)
    data = Fs.readFileSync(faqPath)
    if data.length > 0
      try
        faqDB = JSON.parse data
        faqDB
      catch err
        robot.logger.error "Error parsing JSON data from faq.json: #{err}"

writeFAQ = (faqDB) ->
  Fs.writeFile(faqPath, JSON.stringify faqDB)
        
module.exports = (robot) ->
  robot.respond /faq list/i, (msg) ->
    faqDB = readFAQ()
    list = ''
    for key, value of faqDB
      list += key + '\n'
    msg.send list
      
      
  robot.respond /faq add <([a-zA-Zéèàêôùïî-]+)> <([-a-zA-Z0-9éèàêôùïîç!?#,.:;_ ]+)>/i, (msg) -> 
    faqDB = readFAQ()
    faqDB[msg.match[1]] = msg.match[2]
    writeFAQ faqDB
    msg.send 'La FAQ ' + msg.match[1] + ' a bien été ajoutée !'
    
  robot.respond /faq delete ([a-zA-Z-]+)/i, (msg) -> 
    faqDB = readFAQ()
    delete faqDB[msg.match[1]]
    writeFAQ faqDB
    msg.send 'La FAQ ' + msg.match[1] + ' a bien été supprimée !'
      
  robot.respond /faq print ([a-zA-Z-]+)/i, (msg) ->
    faqDB = readFAQ()
    faq = msg.match[1]
    faq.trim()
    if faqDB.hasOwnProperty faq
      msg.send faqDB[faq]
    else
      msg.send 'La FAQ n\'existe pas.'
      
  robot.respond /faq debug (.*)/i, (msg) ->
    console.log msg.match[1]
