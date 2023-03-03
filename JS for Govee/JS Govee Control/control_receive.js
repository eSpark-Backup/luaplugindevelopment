const dgram = require('dgram');
const client = dgram.createSocket({type:'udp4', reuseAddr:"false"});
const server = dgram.createSocket('udp4');
const PORT = 4003;
const serverPORT = 4002;
const MULTICAST_ADDR = '239.255.255.250';



let MESSAGEpayload= 
'{' +
'  "msg":'+
'      {'+
'        "cmd":"turn", '+
'        "data":'+
'              {'+
'                "value":1'+
'              }'+
'      }'+
'}'


server.bind(serverPORT, () => {
  console.log(`Server listening on port ${serverPORT}...`);
  server.addMembership(MULTICAST_ADDR);
});
server.on('message', (msg, rinfo) => {
    console.log(`Server received message from ${rinfo.address}:${rinfo.port}: ${msg}`);
    // Parse the message payload to extract the "value" field
    let message = JSON.parse(MESSAGEpayload);
    let value = message.msg.data.value;
    // Check the value and control the switch accordingly
    if (value == '0') 
        {
          console.log("Switch is off");
          // TODO: Control the switch to turn it off
        } else if (value == '1') 
                {
                  console.log("Switch is on");
                  // TODO: Control the switch to turn it on
                } 
    else 
        {
          console.log("Invalid value");
        }
  });












/* 


const dgram = require('dgram');
const client = dgram.createSocket({type:'udp4', reuseAddr:"false"});

const PORT = 4002;
const MULTICAST_ADDR = '239.255.255.250';
//const MULTICAST_ADDR = '127.0.0.1';
//const MESSAGE = '{"msg":{    "cmd":"scan",    "data":{      "account_topic":"reserve"    }  }}';

const MESSAGE = 
'{'+
'    "msg":'+
'    {'+
'      "cmd":"turn",'+
'      "data":'+
'        {'+
'            "value":0'+
'        }'+
'    }'+
'}';



client.send(MESSAGE, PORT, MULTICAST_ADDR, (err) => {
  if (err) throw err;
  console.log('Client sent message to server...');
  client.close();
});


 */