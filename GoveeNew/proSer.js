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
'      "value":0'
'    }'
'  }'
'}';

server.on('listening', () => {
    // Server address it’s using to listen
  
    const address = server.address()
  
    console.log('Listening to ', 'Address: ', address.address, 'Port: ', address.port)
  })


