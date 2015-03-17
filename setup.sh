npm install meshblu-util -g
if [ -z "$1" ]
  then
    echo "Must pass in a username: ./setup.sh 'joe-smith' (no-spaces)"
    exit 1
fi

if [ -f "./meshblu.json" ]
  then
    echo "meshblu.json exists, updating device instead..."
  else
    echo "Creating device..."
    meshblu-util register -t octoblu:chatter > meshblu.json
fi

echo "Updating device..."
meshblu-util update ./meshblu.json -d "{\"discoverWhitelist\":null,\"recieveWhitelist\":null,\"name\":\"$1\"}" > /dev/null 

echo "Generating keygen..."
meshblu-util keygen ./meshblu.json

echo "Running npm install..."
npm install