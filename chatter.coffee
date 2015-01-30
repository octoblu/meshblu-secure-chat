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

    @conn.on 'message', (msg) =>
      return console.log colors.red "#{msg.fromUuid} says: #{msg.payload}" if msg.payload
      return console.log colors.green "#{msg.fromUuid} says: #{msg.decryptedPayload}" if msg.encryptedPayload

    @prompt.on 'line', @onInput

  onInput: (msg) =>
    pieces = msg.split ' '
    msg = []
    while pieces.length
      piece = pieces.shift()
      if piece == '/uuid'
        @friendUuid = pieces.shift()
        continue

      if piece == '/encrypted'
        @encrypted = pieces.shift() == 'true'
        continue

      msg.push piece

    msg = msg.join ' '
    @sendMessage msg if @friendUuid && msg.length

  sendMessage: (msg) =>
    if @encrypted
      @conn.encryptMessage @friendUuid, msg
      return console.log colors.green 'sent message to', @friendUuid

    if !@encrypted
      @conn.message @friendUuid, msg
      return console.log colors.red 'sent message to', @friendUuid

module.exports = Chatter
