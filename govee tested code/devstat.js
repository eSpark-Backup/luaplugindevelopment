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
         // do something
    }
  };

let PayloadStringStatus = '{' + 
'	"msg":{' + 
'	  "cmd":"devStatus",' + 
'	  "data":{' + 
'	  }' + 
'	}' + 
' }';

//validate the IPV4address
function validateIPv4(ipv4data) {
      try{
      const regexp = '[0-9]\+\\.[0-9]\+\\.[0-9]\+\\.[0-9]+'
      const matches = ipv4data.matchAll(regexp);
      return Array.from(matches)[0][0];
      }catch(e){return ' '
    }
}

    client.send(PayloadStringStatus, CommandPORT, ipAddress, (err) => {
      if (err) throw err;
        console.log('Client sent Device Status Command to Server...');
    
    });
    
    
    server.bind(serverPORT, () => {
    console.log(`Server listening on port ${serverPORT}...`);
    server.addMembership(MULTICAST_ADDR);
    });
    
    server.on('message', (msg, rinfo) => {
        stat = msg.toString()
        console.log(`Device Status is : ${stat}`);
        server.close();
      });
      
