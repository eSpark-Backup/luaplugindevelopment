const dgram = require('dgram');
const client = dgram.createSocket({type:'udp4', reuseAddr:"false"});

const DEVICE_IP = '239.255.255.250';
const DEVICE_PORT = 4003;

// Prepare the control command in JSON format
const controlCommand = {
  "msg": {
    "cmd": "turn",
    "data": {
      "value": 1  // set to 0 to turn off
    }
  }
};
const controlCommandJson = JSON.stringify(controlCommand);

// Send the control command to the device
client.send(controlCommandJson, DEVICE_PORT, DEVICE_IP, (err) => {
  if (err) {
    console.error(`Error sending control command: ${err}`);
  } else {
    console.log(`Control command sent to ${DEVICE_IP}:${DEVICE_PORT}`);
  }
  client.close();
});
