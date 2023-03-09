const dgram = require('dgram');
// const client = dgram.createSocket({type:'udp4', reuseAddr:"false"});
// const server = dgram.createSocket('udp4');
const MULTICAST_ADDR = '239.255.255.250';


/////////////////////////////////////////////////// Device Status Query Command //////////////////////////////////////////////////////////
const Statusque_PORT = 4002;
const statusqueue = '{'+
  '  "msg":{'+
'    "cmd":"devstatus",'+
'    "data":{'+
'    }'+
'  }'+
'}';


setTimeout(() => {
const Statusquery= dgram.createSocket({ type: 'udp4', reuseAddr: false });
Statusquery.send(statusqueue, Statusque_PORT, MULTICAST_ADDR, (err) => {
  if (err) throw err;
  console.log('Client send status queue to server...');
Statusquery.close();
})
},3000)

/////////////////////////////////////////////////// Server Reply with Status Payload /////////////////////////////////////////////////////////
const STATUSpayload = '{' +
'  "msg":'+
'      {'+
'        "cmd":"devStatus", '+
'        "data":{'+
'          "onOff":1,'+
'          "brightness":100,'+
'          "color":{'+
'            "r":255,'+
'            "g":128,'+
'            "b":0'+
'          },'+
'          "colorTemInKelvin":7200'+
'        }'+
'      }'+
'}'


    setTimeout(() => {
    if (STATUSpayload) {
      console.log(STATUSpayload);
      // TODO: Control the switch to turn it of
    } else {
      console.log("Invalid value");
    }
  },7000)
 