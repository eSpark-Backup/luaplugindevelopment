const dgram = require('dgram');
const client = dgram.createSocket({type:'udp4', reuseAddr:"false"});
const server = dgram.createSocket('udp4');

const PORT = 4002;
// const serverPORT = 4001;
const MULTICAST_ADDR = '239.255.255.250';
//const MULTICAST_ADDR = '127.0.0.1';

const Brightnesspayload = '{'+
'  "msg":{'+
'    "cmd":"brightness",'+
'    "data":{'+
'      "value":80'+
'    }'+
'  }'+
'}';
server

client.send(Brightnesspayload, PORT, MULTICAST_ADDR, (err) => {
  if (err) throw err;
  console.log('Client sett brightness to server...');
client.close();
})