meshbluConfig = require './meshblu.json'
Chatter = require './chatter'

chatter = new Chatter meshbluConfig

chatter.start()
