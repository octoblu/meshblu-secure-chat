readline = require 'readline'
meshblu = require 'meshblu'
colors = require 'colors/safe'

class Chatter
  constructor: (@meshbluConfig)->
    @prompt = readline.createInterface
      input:  process.stdin,
      output: process.stdout

  start: =>
    console.log colors.cyan "Your UUID is #{@meshbluConfig.uuid}"

    @conn = meshblu.createConnection @meshbluConfig

    @prompt.question 'Who do you want to chat with? (uuid) > ', (@friendUuid) =>

    @conn.on 'message', (msg) =>
      return console.log colors.red "#{msg.fromUuid} says: #{msg.payload}" if msg.payload
      return console.log colors.green "#{msg.fromUuid} says: #{msg.decryptedPayload}" if msg.encryptedPayload

    @prompt.on 'line', (msg) =>
      @conn.encryptMessage @friendUuid, msg if @friendUuid


module.exports = Chatter
