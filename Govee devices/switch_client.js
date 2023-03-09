const dgram = require('dgram');
const client = dgram.createSocket({type:'udp4', reuseAddr:"false"});
const server = dgram.createSocket('udp4');

const PORT = 4002;
// const serverPORT = 4001;
const MULTICAST_ADDR = '239.255.255.250';
//const MULTICAST_ADDR = '127.0.0.1';

const MESSAGEpayload = '{'+
'  "msg":{'+
'    "cmd":"scan",'+
'    "data":{'+
'      "value":0'+
'    }'+
'  }'+
'}';

client.send(MESSAGEpayload, PORT, MULTICAST_ADDR, (err) => {
  if (err) throw err;
  console.log('Client sent message to server...');
client.close();
})