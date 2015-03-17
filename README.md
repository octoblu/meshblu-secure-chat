## Meshblu Secure Chat

Securely or not-so-securely send message from one devices to another.

### Setup:
`./setup.sh joe-smith` - username must not include spaces

### Manual Setup:
    npm install meshblu-util -g
    npm install
    meshblu-util register -t octoblu:chatter > meshblu.json
    meshblu-util update ./meshblu.json -d "{\"discoverWhitelist\":null,\"recieveWhitelist\":null,\"name\":\"joe-smith\"}" 
    meshblu-util keygen ./meshblu.json

### Usage:

`npm start`

First define the uuid or username of the device you want to message.
`/uuid 3b75dec5-3a89-45a5-99d1-cc0fe697ce66`
or
`/username joe-smith`

Once the device is specified you can send as many messages as you want. If you want to send a message to someone new just specify the uuid or username again.

To set the encryption, use `/encrypted true` or `/encrypted false`

To refresh the users use, `/refresh`

You can also combine commands into one line. Example: `/encrypted true /username joe-smith Hello, how are you?`

