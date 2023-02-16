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


server.bind(PORT, () => {
  server.addMembership(MULTICAST_ADDR);
  console.log(`Server listening on port ${PORT}...`);
});

server.on('message', (msg, rinfo) => {
  console.log(`Server received message from ${rinfo.address}:${rinfo.port}: ${msg}`);
});
