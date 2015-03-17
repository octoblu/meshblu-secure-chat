readline = require 'readline'
meshblu = require 'meshblu'
colors = require 'colors/safe'
_ = require 'lodash'

class Chatter
  constructor: (@meshbluConfig)->
    @devices = {}
    @encrypted = true
    @prompt = readline.createInterface
      input:  process.stdin,
      output: process.stdout

  getChatDevice: (callback=->) =>
    @conn.devices type: 'octoblu:chatter', (response) =>
      return console.error error if response.error?
      _.each response.devices, (device) =>
        @devices[device.name] = device.uuid
      callback() 

  getNameFromDevices: (uuid) =>
    uuidsToNames = _.invert @devices
    uuidsToNames[uuid]

  start: =>
    console.log colors.magenta 'Loading chat service...'
    @conn = meshblu.createConnection @meshbluConfig

    @conn.on 'ready', =>
      @getChatDevice =>
        uuid = @meshbluConfig.uuid
        name = @getNameFromDevices uuid
        console.log colors.cyan "Your username is #{name} and your uuid is #{uuid}"

    @conn.on 'message', (msg) =>
      name = @getNameFromDevices msg.fromUuid || msg.fromUuid
      return console.log colors.magenta '[unencrypted]', colors.red "#{name} says: #{msg.payload}" if msg.payload
      return console.log colors.magenta '[encrypted]', colors.green "#{name} says: #{msg.decryptedPayload}" if msg.encryptedPayload

    @prompt.on 'line', @onInput

  onInput: (msg) =>
    pieces = msg.split ' '
    msg = []
    while pieces.length
      piece = pieces.shift()

      if piece == '/refresh'
        @getChatDevice => console.log 'Devices refreshed.', _.keys @devices
        continue

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
      return console.log colors.green 'sent encrypted message to', @friendUsername, uuid

    unless @encrypted
      @conn.message uuid, msg
      return console.log colors.red 'sent message to', @friendUsername, uuid

module.exports = Chatter
