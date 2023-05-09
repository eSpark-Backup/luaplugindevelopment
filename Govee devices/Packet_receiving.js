const dgram = require('dgram');
const server = dgram.createSocket('udp4');
const client = dgram.createSocket('udp4');
const fs = require('fs');

const port_S = 4002; 

const address = '239.255.255.250';
//const address = '10.100.139.58';

const message = '{'+
'	"msg":{'+
'	  "cmd":"turn",'+
'	  "data":{'+
'		"value":0'+
'	  }'+
'	}'+
'  }';


const command2 = '{'+
'  "msg":{'+
'    "cmd":"scan",'+
'    "data":{'+
'      "ip":"10.100.139.58",'+
'      "device":"1F:80:C5:32:32:36:72:4E",'+
'      "sku":"Hxxxx",'+
'      "bleVersionHard":"3.01.01",'+
'      "bleVersionSoft":"1.03.01",'+
'      "wifiVersionHard":"1.00.10",'+
'      "wifiVersionSoft":"1.02.03"'+
'    }'+
'  }'+
'}';




client.send(command2, port_S, address, (err) => {
  if (err) {
    console.error(err);
  } else {
    console.log('Message sent');
  }
  client.close()
});




/* 

const log = `LOGS APPENDED`;
fs.appendFile('govee.txt', log, (err) => {
  if (err) throw err;
  console.log('Log appended to file');
});server.on('error', (err) => {
  console.error(err);
  server.close();
});server.on('message', (msg, rinfo) => {
  console.log(`Received message: ${msg} from ${rinfo.address}:${rinfo.port}`); });const port_C = 4003;
server.bind(port_C, () => {
  server.addMembership(address, '0.0.0.0');
  console.log(`Listening for messages on port ${port_C}`);
});


 */
