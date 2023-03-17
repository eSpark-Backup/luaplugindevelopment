const dgram = require('dgram');
const client = dgram.createSocket({type:'udp4', reuseAddr:"true"});
const server = dgram.createSocket('udp4');
const servercommand = dgram.createSocket('udp4');

const DiscoveryPORT = 4001;
const CommandPORT = 4003;
const serverPORT = 4002;
const MULTICAST_ADDR = '239.255.255.250';

let SetdeviceOnOff ='1';
const ipAddress  = "10.100.139.58";

function sleep(delayMs) {
  let start = new Date().getTime();
    while (new Date().getTime() < start + delayMs) {
         // do something
    }
  };

let deviceOnOff = '{'+
'	"msg":{'+
'	  "cmd":"turn",'+
'	  "data":{'+
'		"value": '+ SetdeviceOnOff +
'    }'+
'  }'+
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

    
    client.send(deviceOnOff, CommandPORT, ipAddress, (err) => {
      if (err) throw err;
        console.log('Client sent ON/OFF Message to Server...');
        client.close();
    });
    
    
    

