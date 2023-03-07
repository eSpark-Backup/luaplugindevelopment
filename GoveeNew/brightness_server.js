const dgram = require('dgram');
const client = dgram.createSocket({type:'udp4', reuseAddr:"false"});
const server = dgram.createSocket('udp4');
const PORT = 4003;
const serverPORT = 4002;
const MULTICAST_ADDR = '239.255.255.250';
const MESSAGEpayload = '{'+
// '  "msg":{'+
// '    "cmd":"brightness",'+
// '    "data":{'+
// '      "brightness":50'+
// '    }'+
// '  }'+
// '}';
server.bind(serverPORT, () => {
  console.log(`Server listening on port ${serverPORT}...`);
  server.addMembership(MULTICAST_ADDR);
});
server.on('message', (msg, rinfo) => {
    console.log(`Server received message from ${rinfo.address}:`);
    // Parse the message payload to extract the "brightness" field
    let message = JSON.parse(msg);
    let brightness = message.msg.data.value;
    // Check the brightness value and control the brightness accordingly
    if (brightness >= 0 && brightness <= 100) {
      console.log(`Setting brightness to ${brightness}`);
      // TODO: Control the brightness to set it to the desired level
    } else {
      console.log("Invalid brightness value");
    }
  });

