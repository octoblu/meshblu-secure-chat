## Meshblu Secure Chat

Securely or not-so-securely send message from one devices to another.

### Setup:
`./setup 'username'` - username must not include spaces

### Manual Setup:
    npm install meshblu-util -g
    npm install
    meshblu-util register -t octoblu:chatter > meshblu.json
    meshblu-util update ./meshblu.json -d "{\"discoverWhitelist\":null,\"name\":\"$1\"}" 
    meshblu-util keygen ./meshblu.json