readline = require 'readline'
meshblu = require 'meshblu'
colors = require 'colors/safe'
_ = require 'lodash'

class Chatter
  constructor: (@meshbluConfig)->
    @devices = {}
    @prompt = readline.createInterface
      input:  process.stdin,
      output: process.stdout

  searchForDevices: () =>
    @conn.devices type: 'octoblu:chatter', (response) =>
      return console.error error if response.error?
      _.each response.devices, (device) =>
        @devices[device.name] = device.uuid 

  start: =>
    console.log colors.cyan "Your UUID is #{@meshbluConfig.uuid}"

    @conn = meshblu.createConnection @meshbluConfig

    @conn.on 'ready', =>
      @searchForDevices()

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
        @friendUsername = null
        @friendUuid = pieces.shift()
        continue

      if piece == '/username'
        @friendUuid = null
        @friendUsername = pieces.shift()
        continue

      if piece == '/encrypted'
        @encrypted = pieces.shift() == 'true'
        continue

      msg.push piece

    msg = msg.join ' '
    return unless msg.length
    return unless @friendUsername || @friendUuid
    @sendMessage msg

  sendMessage: (msg) =>
    uuid = @devices[@friendUsername] || @friendUuid
    if @encrypted
      @conn.encryptMessage uuid, msg
      return console.log colors.green 'sent message to', @friendUsername, uuid

    if !@encrypted
      @conn.message uuid, msg
      return console.log colors.red 'sent message to', @friendUsername, uuid

module.exports = Chatter
