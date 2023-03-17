const dgram = require('dgram');
const client = dgram.createSocket({type:'udp4', reuseAddr:"true"});
const server = dgram.createSocket('udp4');
const servercommand = dgram.createSocket('udp4');

const DiscoveryPORT = 4001;
const CommandPORT = 4003;
const serverPORT = 4002;
const MULTICAST_ADDR = '239.255.255.250';

let SetBrightness ='86';

const sendBrightness = true;
const ipAddress  = "10.100.139.58";

function sleep(delayMs) {
  let start = new Date().getTime();
    while (new Date().getTime() < start + delayMs) {

    }
  };



let PayloadStringBrightness = '{' + 
'	"msg":{' + 
'	  "cmd":"brightness",' + 
'	  "data":{' + 
'		"value": ' + SetBrightness +
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

    
    //SEND Device Brightness
    client.send(PayloadStringBrightness, CommandPORT, ipAddress, (err) => {
      if (err) throw err;
        console.log('Client sent brightness Message to Server...');
        client.close();
    });
    
    
    
    
