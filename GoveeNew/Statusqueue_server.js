const dgram = require('dgram');
const client = dgram.createSocket({type:'udp4', reuseAddr:"false"});
const server = dgram.createSocket('udp4');
const PORT = 4003;
const serverPORT = 4002;
const MULTICAST_ADDR = '239.255.255.250';
const MESSAGEpayload = '{' +
'  "msg":'+
'      {'+
'        "cmd":"devStatus", '+
'        "data":{'+
'          "onOff":0,'+
'          "brightness":57,'+
'          "color":{'+
'            "r":255,'+
'            "g":128,'+
'            "b":0'+
'          },'+
'          "colorTemInKelvin":7200'+
'        }'+
'      }'+
'}'
server.bind(serverPORT, () => {
  console.log(`Server listening on port ${serverPORT}...`);
  server.addMembership(MULTICAST_ADDR);
});
server.on('message', (msg, rinfo) => {
    console.log(`Server received message from ${rinfo.address}:${rinfo.port}: ${msg}`);
    // Parse the message payload to extract the "value" field
    let message = JSON.parse(msg);

    // Check the value and control the switch accordingly
    if (MESSAGEpayload) {
      console.log(MESSAGEpayload);
      // TODO: Control the switch to turn it of
    } else {
      console.log("Invalid value");
    }
  });