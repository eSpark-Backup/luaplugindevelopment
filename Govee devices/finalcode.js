const dgram = require('dgram');
const client = dgram.createSocket({type:'udp4', reuseAddr:"true"});
const server = dgram.createSocket('udp4');
const servercommand = dgram.createSocket('udp4');

const DiscoveryPORT = 4001;
const CommandPORT = 4003;
const serverPORT = 4002;
const MULTICAST_ADDR = '239.255.255.250';

let SetdeviceOnOff =0;
let SetBrightness =50;
let ColorRED =0;
let ColorGREEN =0;
let ColorBLUE =0;
let ColorTemperature =0;
let deviceIPFound ="";

const sendBrightness = true;
const sendRGB_ColorTemp = true;


function sleep(delayMs) {
  let start = new Date().getTime();
    while (new Date().getTime() < start + delayMs) {
         // do something
    }
  };


//Discovery Message
let mESSAGEpayload = '{'+
'  "msg":{'+
'    "cmd":"scan",'+
'    "data":{'+
'      "account_topic":"reserve"'+
'    }'+
'  }'+
'}';

let devstat = '{'+
'  "msg":{'+
'    "cmd":"devStatus",'+
'    "data":{'+
'    }'+
'  }'+
'}';

/////////////////////////////////////////////////// Server Reply with Status Payload /////////////////////////////////////////////////////////
let mESSAGEpayloadRGB = '{' +
'  "msg":{'+
'    "cmd":"colorwc",'+
'    "data":{'+
'      "color":{'+
'        "r":'+ColorRED+','+
'        "g":'+ColorGREEN+','+
'        "b":'+ColorBLUE
'      },'+
'      "colorTemInKelvin":'+ColorTemperature
'    }'+
'  }'+
'}';

let deviceOnOff = '{'+
'  "msg":{'+
'    "cmd":"scan",'+
'    "data":{'+
'      "value":'+SetdeviceOnOff
'    }'+
'  }'+
'}';


let brightnessPayLoad = '{'+
'  "msg":{'+
'    "cmd":"brightness",'+
'    "data":{'+
'      "value":'+SetBrightness
'    }'+
'  }'+
'}';


//validate the IPV4address
function validateIPv4(ipv4data) {
  
    //if (isString(ipv4data) && /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(ipv4data)) {
      //mDNSdevicesObject.deviceIP4 = checkQueryResponseAnswers.answers[cntr].data;
      try{
      const regexp = '[0-9]\+\\.[0-9]\+\\.[0-9]\+\\.[0-9]+'
      const matches = ipv4data.matchAll(regexp);
      return Array.from(matches)[0][0];
      }catch(e){return ' '
    }
}
console.log('****************Before Sending Discovery Packet*************...');
//SEND Discovery Packet
client.send(mESSAGEpayload, DiscoveryPORT, MULTICAST_ADDR, (err) => {
  if (err) throw err;
    console.log('Client sent Discovery Message to Server...');
});

console.log('****************Before Server Listening on 4002 *************...');
//server listen for get discovery packet
server.bind(serverPORT, () => {
  console.log(`Server listening on port ${serverPORT}...`);
  server.addMembership(MULTICAST_ADDR);
});

console.log('1 Before Sleeping to 2 seconds...');
sleep(2000);

server.on('message', (revdata, rinfo) => {
  console.log(`Server received message port 4002 from ${rinfo.address}:${rinfo.port}: ${revdata}`);
  //deviceIPFound = revdata.msg.data.ip;
  deviceIPFound = validateIPv4(`${rinfo.address}`)
  
  if(deviceIPFound.length>=8){
    console.log('2 Before Sleeping to 2 seconds...');
    sleep(2000);
    
      
    // console.log('****************Before Sending Get Status Packet*************...');
    // //SEND Get Status Packet
    // client.send(devstat, CommandPORT, MULTICAST_ADDR, (err) => {
    //   if (err) throw err;
    //     console.log('Client sent Device Status Message to Server...');
    // });
    
    //receive packets for device Status
    // servercommand.on('message', (revdata, rinfo) => {
    //   console.log(`Server received message from ${rinfo.address}:${rinfo.port}: ${msg}`);
    // '        "r":'+ColorRED+','+
    // '        "g":'+ColorGREEN+','+
    // '        "b":'+ColorBLUE
    // '      },'+
    // '      "colorTemInKelvin":'+ColorTemperature
    
    // SetdeviceOnOff = revdata.msg.data.onOff;
    // SetBrightness = revdata.msg.data.brightness;
    // ColorRED = revdata.msg.data.color.r;
    // ColorGREEN = revdata.msg.data.color.g;
    // ColorBLUE = revdata.msg.data.color.b;
    // ColorTemperature = revdata.msg.colorTemInKelvin;
    // servercommand.close();
    // });
    
    
    //SEND Device Set ON/OFF
    client.send(deviceOnOff, CommandPORT, MULTICAST_ADDR, (err) => {
      if (err) throw err;
        console.log('Client sent ON/OFF Message to Server...');
    });
    sleep(4000);
    
    
    
    console.log('****************Before Sending Set Broghtness Packet*************...');
    if (sendBrightness)
    {
      brightnessPayLoad = '{'+
    '  "msg":{'+
    '    "cmd":"brightness",'+
    '    "data":{'+
    '      "value":'+SetBrightness
    '    }'+
    '  }'+
    '}';
    
    
    //SEND Device Brightness
    client.send(brightnessPayLoad, CommandPORT, MULTICAST_ADDR, (err) => {
      if (err) throw err;
        console.log('Client sent brightness Message to Server...');
    });
    }
    
    sleep(4000);
    
    console.log('****************Before Sending Set RGB Packet*************...');
    if (sendRGB_ColorTemp)
    {
     
      mESSAGEpayloadRGB = '{' +
    '  "msg":{'+
    '    "cmd":"colorwc",'+
    '    "data":{'+
    '      "color":{'+
    '        "r":'+ColorRED+','+
    '        "g":'+ColorGREEN+','+
    '        "b":'+ColorBLUE
    '      },'+
    '      "colorTemInKelvin":'+ColorTemperature
    '    }'+
    '  }'+
    '}';
    
    //SEND Device RGB and Color Temp
    client.send(mESSAGEpayloadRGB, CommandPORT, MULTICAST_ADDR, (err) => {
      if (err) throw err;
        console.log('Client sent RGB and ColorTemperature Message to Server...');
    
    });
    
    }
    console.log('****************All Message sent from server*************...');
    // client.close();
  }
  

console.log('****************Ending Program*************...');
  
  
  server.close();
});


  
