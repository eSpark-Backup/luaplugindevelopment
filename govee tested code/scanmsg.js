const dgram = require('dgram');
const client = dgram.createSocket({type:'udp4', reuseAddr:"true"});
const server = dgram.createSocket('udp4');
const servercommand = dgram.createSocket('udp4');

const DiscoveryPORT = 4001;
const CommandPORT = 4003;
const serverPORT = 4002;
const MULTICAST_ADDR = '239.255.255.250';
const ipAddress  = "10.100.139.58";

function sleep(delayMs) {
  let start = new Date().getTime();
    while (new Date().getTime() < start + delayMs) {

    }
  };

//Discovery Message
let PayloadString ='{' + 
'  "msg":{' + 
'    "cmd":"scan",' + 
'    "data":{' + 
'      "account_topic":"reserve"' + 
'    }' + 
'  }' +
'}';

//validate the IPV4address
function validateIPv4(ipv4data) {
      try{
      const regexp = '[0-9]\+\\.[0-9]\+\\.[0-9]\+\\.[0-9]+'
      const matches = ipv4data.matchAll(regexp);
      return Array.from(matches)[0][0];
      }catch(e){return ' '
    }
}

    client.send(PayloadString, DiscoveryPORT, MULTICAST_ADDR, (err) => {
      if (err) throw err;
        console.log('Client sent Scan Command to Server...');
        client.close();
    
    });
    
    
    server.bind(serverPORT, () => {
    console.log(`Server listening on port ${serverPORT}...`);
    server.addMembership(MULTICAST_ADDR);
    });

    
    server.on('message', (msg, rinfo) => {
        infor = msg.toString()
        console.log(`Device Information is : ${infor}`);
        server.close();
      });
      
