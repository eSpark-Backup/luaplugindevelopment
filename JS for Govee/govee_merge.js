const dgram = require('dgram');
const client = dgram.createSocket({type:'udp4', reuseAddr:"false"});
const server = dgram.createSocket('udp4');

const PORT = 4001;
const serverPORT = 4002;
const MULTICAST_ADDR = '239.255.255.250';
const MESSAGEpayload = '{'+
'  "msg":{'+
'    "cmd":"scan",'+
'    "data":{'+
'      "account_topic":"reserve"'+
'    }'+
'  }'+
'}';

client.send(MESSAGEpayload, PORT, MULTICAST_ADDR, (err) => {
  if (err) throw err;
  console.log('Client sent message to server...');
});


server.bind(serverPORT, () => {
  console.log(`Server listening on port ${serverPORT}...`);
  server.addMembership(MULTICAST_ADDR);

});

server.on('message', (msg, rinfo) => {
  console.log(`Server received message from ${rinfo.address}:${rinfo.port}: ${msg}`);
});
