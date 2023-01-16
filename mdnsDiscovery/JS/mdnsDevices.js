var mdns = require('./')()
const fs = require('fs');
let mapDevices = new Map();

//let approvedDevicesList = new Map();
//let approvedDevicesListExist =false

function isString(x) {
  return Object.prototype.toString.call(x) === "[object String]"
}


function padTo2Digits(num) {
  return num.toString().padStart(2, '0');
}

function formatDate(date) {
  return (
    [
      date.getFullYear(),
      padTo2Digits(date.getMonth() + 1),
      padTo2Digits(date.getDate()),
    ].join('-') +
    ' ' +
    [
      padTo2Digits(date.getHours()),
      padTo2Digits(date.getMinutes()),
      padTo2Digits(date.getSeconds()),
    ].join(':')
  );
}

let mDNSdevicesObject = {
	deviceName : "value",
  	deviceType : " ",
  	deviceIP4 : " ",
  	deviceData : " "
};

let mDNSdevicesObjectWEBUI = {
	deviceName : "value",
	deviceIP4 : " "
};

mdns.on('warning', function (err) {
  console.log(err.stack)
})

mdns.on('response', function (response) {


//if(!approvedDevicesListExist)//
//{
//	approvedDevicesList.set('shelly','1')
//	approvedDevicesList.set('ezlo','1')
//	approvedDevicesList.set('airplay','1')
//	approvedDevicesList.set('mi-connect','1')
//	approvedDevicesList.set('hue','1')
//	approvedDevicesList.set('android','1')
//	approvedDevicesList.set('apple','1')
//	approvedDevicesList.set('sonos','1')
//	approvedDevicesListExist = true
//console.log(approvedDevicesListExist,approvedDevicesList)
//	}




fs.appendFile('mDNSfile.log', formatDate(new Date()) + JSON.stringify(response)+'\n\r', err => {
  if (err) { console.error(err); }
  });



if(response.answers !==undefined)
      try {
  	var cntr=0


	if(response.answers[cntr] != 'undefined')
		  {
//if(approvedDevicesList.has(response.answers[cntr].name.toLocaleLowerCase()))

//if (response.additionals[cntr].name.toLocaleLowerCase().includes('shelly') || response.additionals[cntr].name.toLocaleLowerCase().includes('ezlo') || response.additionals[cntr].name.toLocaleLowerCase().includes('airplay') || response.additionals[cntr].name.toLocaleLowerCase().includes('hue') || response.additionals[cntr].name.toLocaleLowerCase().includes('mi-connect') || response.additionals[cntr].name.toLocaleLowerCase().includes('apple') || response.additionals[cntr].name.toLocaleLowerCase().includes('sonos'))
{

	try{console.log('********************************************'+response.answers[cntr].name+' Device Found********************************************')} catch (e) {console.log('********************************************New Device Found********************************************') }


fs.appendFile('mDNSfile.log', formatDate(new Date()) + '********************************************New Device Found********************************************'+'\n\r', err => {
  if (err) { console.error(err); }
  });

//let mDNSdevicesObject = {
//  deviceName : " ",
//  deviceType : " ",
//  deviceIP4 : " ",
//  deviceData : " "
//};

		while (true)
				{
	//console.log('******* Details'+cntr+' *******', response.answers[cntr].name , response.answers[cntr].data)

mDNSdevicesObject.deviceName = response.answers[cntr].name;
mDNSdevicesObject.deviceType = response.answers[cntr].type;
mDNSdevicesObject.deviceIP4=""

if (isString(response.answers[cntr].data) && /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(response.answers[cntr].data))
  {
    mDNSdevicesObject.deviceIP4 = response.answers[cntr].data;
  }

mDNSdevicesObject.deviceData = response.answers[cntr].ttl;

if (mDNSdevicesObject.deviceIP4.length>1)
{

mDNSdevicesObjectWEBUI.deviceName=mDNSdevicesObject.deviceName
mDNSdevicesObjectWEBUI.deviceIP4=mDNSdevicesObject.deviceIP4

if (!mapDevices.has(mDNSdevicesObject.deviceName))
{
	console.log('********************************************1111111111111111111111111111111111111111111111111111111111111********************************************************',mDNSdevicesObjectWEBUI);

mapDevices.set(mDNSdevicesObject.deviceName,mDNSdevicesObject.deviceIP4)//map.forEach (myFunction);

fs.appendFile('mDNSDevices.json', JSON.stringify(mDNSdevicesObjectWEBUI)+"\r\n", err => {
  if (err) { console.error(err); }
  });


}

}

cntr = cntr+1
console.log(mDNSdevicesObject.deviceName,mDNSdevicesObject.deviceType,mDNSdevicesObject.deviceIP4,mDNSdevicesObject.deviceData)
}
}

	}

      } catch (e) {
      }


if(response.additionals !==undefined)
      try {
  	cntr=0


	if(response.additionals[cntr] != 'undefined')
		  {


//if(approvedDevicesList.has(response.additionals[cntr].name.toLocaleLowerCase()))

//if (response.additionals[cntr].name.toLocaleLowerCase().includes('shelly') || response.additionals[cntr].name.toLocaleLowerCase().includes('ezlo') || response.additionals[cntr].name.toLocaleLowerCase().includes('airplay') || response.additionals[cntr].name.toLocaleLowerCase().includes('hue') || response.additionals[cntr].name.toLocaleLowerCase().includes('mi-connect') || response.additionals[cntr].name.toLocaleLowerCase().includes('apple') || response.additionals[cntr].name.toLocaleLowerCase().includes('sonos'))
{
	try{console.log('********************************************'+response.additionals[cntr].name+' Device Found********************************************')}  catch (e) {console.log('********************************************New Device Found********************************************') }

	fs.appendFile('mDNSfile.log', formatDate(new Date()) + JSON.stringify(response)+'\n\r', err => {
	  if (err) { console.error(err); }
	  });

		while (true)
				{

		mDNSdevicesObject.deviceName = response.additionals[cntr].name;
		mDNSdevicesObject.deviceType = response.additionals[cntr].type;
		mDNSdevicesObject.deviceIP4=""

		if (isString(response.additionals[cntr].data) && /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(response.additionals[cntr].data))
		  {
		    mDNSdevicesObject.deviceIP4 = response.additionals[cntr].data;
		  }

		mDNSdevicesObject.deviceData = response.additionals[cntr].ttl;


if (mDNSdevicesObject.deviceIP4.length>1)
{

mDNSdevicesObjectWEBUI.deviceName=mDNSdevicesObject.deviceName
mDNSdevicesObjectWEBUI.deviceIP4=mDNSdevicesObject.deviceIP4

if (!mapDevices.has(mDNSdevicesObject.deviceName))
{

	console.log('********************************************2222222222222222222222222222222222222222222222222222222********************************************************',mDNSdevicesObjectWEBUI);

	mapDevices.set(mDNSdevicesObject.deviceName,mDNSdevicesObject.deviceIP4)

fs.appendFile('mDNSDevices.json', JSON.stringify(mDNSdevicesObjectWEBUI)+"\r\n", err => {
  if (err) { console.error(err); }
  });


}
}
		cntr = cntr+1
		console.log(mDNSdevicesObject.deviceName,mDNSdevicesObject.deviceType,mDNSdevicesObject.deviceIP4,mDNSdevicesObject.deviceData)

}
}
	}
      } catch (e) {
		return
      }
})

mdns.on('query', function (query) {

  query.questions.forEach(function (q) {
	  console.log(q)
    if (q.type === 'A' && q.name === '_http._tcp.local') {
      // send an A-record response for example.local
      mdns.respond({
        answers: [{
          name: '_http._tcp.local',
          type: 'A',
          ttl: 300,
          data: '192.168.18.1'
        }]
      })
    }
  })
})

// lets query for an A-record for example.local
mdns.query({
  questions: [{
    name: '_http._tcp.local',
    type: 'A'
  }]
})
