
const dgram = require('dgram');
const client = dgram.createSocket({type:'udp4', reuseAddr:"false"});
const server = dgram.createSocket('udp4');

const PORT = 4002;
// const serverPORT = 4001;
const MULTICAST_ADDR = '239.255.255.250';
//const MULTICAST_ADDR = '127.0.0.1';

const BrightnessPORT = 4002;

const Brightnesspayload = {
  msg:{
    cmd:"brightness",
    data:{
      value:80
    }
  }
};
server
setTimeout(() => {
const brightnesscontrol= dgram.createSocket({ type: 'udp4', reuseAddr: false });
client.send(JSON.stringify(Brightnesspayload), BrightnessPORT, MULTICAST_ADDR, (err) => {
  if (err) throw err;
  console.log('Client sett brightness to server...');
brightnesscontrol.close();
})
},3000);




///////////////////////////////////// Server sett the brightness //////////////////////////////////////////////
setTimeout(() => {

  if (Brightnesspayload) 
  {
      const brightness= Brightnesspayload.msg.data.value;
    		if (brightness >= 0 && brightness <= 100) {
      			console.log(`Setting brightness to ${brightness}`);
        }
    else 
        {
          console.log("Invalid value Try again");
        }

  }
}, 5000);