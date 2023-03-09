
////////////////////////////////////  CLIENT SCAN ///////////////////////////////////////////////////////
const dgram = require('dgram');
const client = dgram.createSocket({type:'udp4', reuseAddr:"false"});

const PORT = 4001;
const MULTICAST_ADDR = '239.255.255.250';

//masb-discovery message
const MESSAGE =
'{'+
'"msg":{'+
'      "cmd":"scan",'+
'      "data":'+
'            {'+
'              "account_topic":"reserve"'+
'            }'+
'      }'+
'};'


////////////////////////////////////  SERVER REPLY WITH IP Address//////////////////////////////////////////////////////

const server = dgram.createSocket('udp4');

const message =
'  {'+
'    "msg":{ '+
'      "cmd":"scan",'+
'      "data":{'+
'        "ip":"192.168.1.23",'+
'        "device":"1F:80:C5:32:32:36:72:4E",'+
'        "sku":"Hxxxx",'+
'        "bleVersionHard":"3.01.01",'+
'        "bleVersionSoft":"1.03.01",'+
'        "wifiVersionHard":"1.00.10",'+
'        "wifiVersionSoft":"1.02.03"'+
'      }'+
'    }'+
'  }'

const ServerPORT = 4002;

    server.bind(ServerPORT, () => {
      server.addMembership(MULTICAST_ADDR);
      console.log(`Server listening on port ${ServerPORT}...`);
    });


    client.send(MESSAGE, PORT, MULTICAST_ADDR, (err) => {
      if (err) throw err;
      console.log('Client sent message to server...');
      client.close();
    });

    server.close(() => {
      //console.log('Server socket closed.');
    });


let value;
const mesg = JSON.parse(message);
setTimeout(function()
  {
    value = mesg.msg.data.ip;
    console.log(`Server received message from: ${value}`);
  }, 2000);


////////////////////////////////////  CLIENT CONTROL VALUE ON/OFF ///////////////////////////////////////////////////////

const ControlPORT = 4003;
setTimeout(() => {
if (value)
    {
		////masb-write in govee format
        MESSAGEpayload =

'{'+
    '"msg": {' +
    '  "cmd": "turn",' +
        ' "data": {' +
    '  "value": 1'+//masb-add to variable
    ' }'+
    '}'+
'}'

        const clientControl = dgram.createSocket({ type: 'udp4', reuseAddr: false });
        ////masb-govee not understan in sending json format
        clientControl.send((MESSAGEpayload), ControlPORT, value, (err) => {
            if (err) throw err;
            console.log('Client sent control command to server...');
            clientControl.close();
          })

    }
else
    {
        console.log("No IP detected")
    }

}, 5000);




/////////////////////////////////////  SERVER REPLY ON/OFF   //////////////////////////////////////////


setTimeout(() => {

  if (MESSAGEpayload)
  {
	  //masb-convert in json to read the value
      const value = JSON.parse(MESSAGEpayload).msg.data.value;

    if (value == '0')
                    {
                      console.log("Switch is off");
                    }
    else if (value == '1')
                            {
                              console.log("Switch is on");
                            }
    else
        {
          console.log("Invalid value Try again");
        }

  }
}, 7000);


// ///////////////////////////////////// Client set Brightness Control //////////////////////////////////////////////

const BrightnessPORT = 4002;

////masb-write in govee format
const Brightnesspayload =

'{'+
    '"msg": {' +
    '  "cmd": "brightness",' +
        ' "data": {' +
    '  "value": 80'+//masb-add to variable
    ' }'+
    '}'+
'}'
server
setTimeout(() => {
const brightnesscontrol= dgram.createSocket({ type: 'udp4', reuseAddr: false });
////masb-govee not understan in sending json format
brightnesscontrol.send((Brightnesspayload), BrightnessPORT, MULTICAST_ADDR, (err) => {
  if (err) throw err;
  console.log('Client send brightness to server...');
brightnesscontrol.close();
})
},9000);




///////////////////////////////////// Server sett the brightness //////////////////////////////////////////////
setTimeout(() => {

  if (Brightnesspayload)
  {
      const brightness= JSON.parse(Brightnesspayload).msg.data.value;
    		if (brightness >= 0 && brightness <= 100) {
      			console.log(`Setting brightness to ${brightness}`);
        }
    else
        {
          console.log("Invalid value Try again");
        }

  }
}, 12000);




//////////////////////////////////////////////// Device Status Query Command //////////////////////////////////////////////////////////
const Statusquery_PORT = 4002;
const Statusquerypayload = '{'+
  '  "msg":{'+
'    "cmd":"devstatus",'+
'    "data":{'+
'    }'+
'  }'+
'}';


setTimeout(() => {
const Statusquery= dgram.createSocket({ type: 'udp4', reuseAddr: false });
Statusquery.send(Statusquerypayload, Statusquery_PORT, MULTICAST_ADDR, (err) => {
  if (err) throw err;
  console.log('Client send status queue to server...');
Statusquery.close();
})
},14000)

/////////////////////////////////////////////////// Server Reply with Status Payload /////////////////////////////////////////////////////////
const Replyquerypayload = '{' +
'  "msg":'+
'      {'+
'        "cmd":"devStatus", '+
'        "data":{'+
'          "onOff":0,'+
'          "brightness":100`,'+
'          "color":{'+
'            "r":255,'+
'            "g":0,'+
'            "b":0'+
'          },'+
'          "colorTemInKelvin":7200'+
'        }'+
'      }'+
'}'
// According to the rule if you set a temperater which is greater 10  it will be set & other it will be rgb

    setTimeout(() => {
    if (Replyquerypayload) {
      console.log(Replyquerypayload);
    } else {
      console.log("Invalid value");
    }
  },18000)
