const dgram = require('dgram');
const client = dgram.createSocket({type:'udp4', reuseAddr:"true"});
const server = dgram.createSocket('udp4');
const servercommand = dgram.createSocket('udp4');

const DiscoveryPORT = 4001;
const CommandPORT = 4003;
const serverPORT = 4002;
const MULTICAST_ADDR = '239.255.255.250';

let ColorRED ='232';
let ColorGREEN ='162';
let ColorBLUE ='10';
let ColorTemperature ='0';
const sendRGB_ColorTemp = true;
const ipAddress  = "10.100.139.58";

function sleep(delayMs) {
  let start = new Date().getTime();
    while (new Date().getTime() < start + delayMs) {
         // do something
    }
  };


let mESSAGEpayloadRGB ='{' +
'	"msg":{' +
'	  "cmd":"colorwc",' +
'	  "data":{' +
'		"color":{' +
'		  "r":' +ColorRED +',' +
'		  "g":' +ColorGREEN +',' +
'		  "b":' +ColorBLUE +
'		},' +
'		"colorTemInKelvin":' + ColorTemperature +
'	  }' +
'	}' +
'  }';




//validate the IPV4address
function validateIPv4(ipv4data) {
  
      try{
      const regexp = '[0-9]\+\\.[0-9]\+\\.[0-9]\+\\.[0-9]+'
      const matches = ipv4data.matchAll(regexp);
      return Array.from(matches)[0][0];
      }catch(e){return ' '
    }
}


    client.send(mESSAGEpayloadRGB, CommandPORT, ipAddress, (err) => {
      if (err) throw err;
        console.log('Client sent RGB and ColorTemperature Message to Server...');
        client.close();
    
    });




  
