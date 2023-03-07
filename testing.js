
////////////////////////////////////  CLIENT SCAN ///////////////////////////////////////////////////////
const dgram = require('dgram');
const client = dgram.createSocket({type:'udp4', reuseAddr:"false"});

const PORT = 4001;
const MULTICAST_ADDR = '239.255.255.250';
//const MESSAGE = '{"msg":{    "cmd":"scan",    "data":{      "account_topic":"reserve"    }  }}';


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
let MESSAGEpayload
setTimeout(() => {
if (value) 
    { 
        MESSAGEpayload = 

        {
          msg: {
            cmd: "scan",
            data: {
              value: 1
            }
          }
        };

        const clientControl = dgram.createSocket({ type: 'udp4', reuseAddr: false });
        clientControl.send(JSON.stringify(MESSAGEpayload), ControlPORT, value, (err) => {
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
      const value = MESSAGEpayload.msg.data.value;

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
}, 5000);
