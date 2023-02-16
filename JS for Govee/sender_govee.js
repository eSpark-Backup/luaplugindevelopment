const dgram = require('dgram');
const client = dgram.createSocket({type:'udp4', reuseAddr:"false"});

const PORT = 4001;
const MULTICAST_ADDR = '239.255.255.250';
const MESSAGE = '{"msg":{    "cmd":"scan",    "data":{      "account_topic":"reserve"    }  }}';

client.send(MESSAGE, PORT, MULTICAST_ADDR, (err) => {
  if (err) throw err;
  console.log('Client sent message to server...');
  client.close();
});
