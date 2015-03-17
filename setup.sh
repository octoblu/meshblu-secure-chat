if [ -z "$1" ]
  then
    echo "Must pass in a username: ./setup.sh 'karate-master' (no-spaces)"
    exit 1
fi

npm install meshblu-util -g
npm install
meshblu-util register -t octoblu:chatter > meshblu.json
meshblu-util update ./meshblu.json -d "{\"discoverWhitelist\":null,\"recieveWhitelist\":null,\"name\":\"$1\"}" > /dev/null 
meshblu-util keygen ./meshblu.json