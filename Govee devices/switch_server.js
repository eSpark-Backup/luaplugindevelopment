const dgram = require('dgram');
const client = dgram.createSocket({type:'udp4', reuseAddr:"false"});
const server = dgram.createSocket('udp4');
const PORT = 4003;
const serverPORT = 4002;
const MULTICAST_ADDR = '239.255.255.250';
const MESSAGEpayload = '{'+
'  "msg":{'+
'    "cmd":"scan",'+
'    "data":{'+
'      "value":0'+
'    }'+
'  }'+
'}';
server.bind(serverPORT, () => {
  console.log(`Server listening on port ${serverPORT}...`);
  server.addMembership(MULTICAST_ADDR);
});
server.on('message', (msg, rinfo) => {
    console.log(`Server received message from ${rinfo.address}:${rinfo.port}: ${msg}`);
    // Parse the message payload to extract the "value" field
    let message = JSON.parse(msg);
    let value = message.msg.data.value;
    // Check the value and control the switch accordingly
    if (value == "0") {
      console.log("Switch is off");
      // TODO: Control the switch to turn it off
    } else if (value == "1") {
      console.log("Switch is on");
      // TODO: Control the switch to turn it on
    } else {
      console.log("Invalid value");
    }
  });