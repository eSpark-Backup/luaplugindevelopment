var mdns = require('./')()
const fs = require('fs');
let mapDevices = new Map();

//supporting datetime methods
function padTo2Digits(num) {
  return num.toString().padStart(2, '0');
}

//supporting datetime methods
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


//validate the IPV4address
function validateIPv4(ipv4data) {

  try{
  const regexp = '[0-9]\+\\.[0-9]\+\\.[0-9]\+\\.[0-9]+'
  const matches = ipv4data.matchAll(regexp);
  return Array.from(matches)[0][0];
  }catch(e){return ' '
}
}

//validate the MacAddress
function validateMacAddress(macData) {

try{
  const regexp = '([0-9a-fA-F]{2}[:.-]?){5}[0-9a-fA-F]{2}';
  const matches = macData.matchAll(regexp);
  return Array.from(matches)[0][0];
  }catch(e){return ' '
}
}

//validate the IPV6address
function validateIPv6(ipv6data) {
try{
  const regexp = '(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))';
  const matches = ipv6data.matchAll(regexp);
  return Array.from(matches)[0][0];
  }catch(e){return ' '
}

}

//validate the commentizeLogs
function validateCommentizeLogs(devnameData) {
try{
  const highlightNames = "********************************************"
return highlightNames + devnameData + '  Device Found' + highlightNames

}
catch(e){return devnameData}

}


//validate the DeviceName
function validateDeviceNameSmartThing(devnameData) {
  try{
  const regexp = /smartthings[\s*A_Za-z0-9\_\.\-]*/gi
  const matches = devnameData.match(regexp)
  
  return Array.from(matches)[0]
  
  }catch(e){return ' '
  }
  
  }

//Specific function for SmartThing Device
function queryAnswersSmartThing(checkQueryResponseAnswers) {

  let responseJsonStr = JSON.stringify(checkQueryResponseAnswers);

  var srchResponse = responseJsonStr.toLocaleLowerCase()

  //Only smartthings device will be filtered that data found in Answers packet of response
  if (srchResponse.includes('smartthings')) {

    try { mDNSdevicesObjectWEBUI.deviceName = validateDeviceNameSmartThing(srchResponse);} catch (e) { }
    try { mDNSdevicesObjectWEBUI.deviceModel = mDNSdevicesObjectWEBUI.deviceName; } catch (e) { mDNSdevicesObjectWEBUI.deviceModel = ''; }
    try { mDNSdevicesObjectWEBUI.deviceIP4 = validateIPv4(responseJsonStr) } catch (e) { }
    try { mDNSdevicesObjectWEBUI.deviceMac = validateMacAddress(responseJsonStr) } catch (e) { }
    try { mDNSdevicesObjectWEBUI.deviceIP6 = validateIPv6(responseJsonStr) } catch (e) { }

    //Dictionary mustnot have the same Attribute already
    if (!mapDevices.has(mDNSdevicesObjectWEBUI.deviceName)) {

      //Save the dictionary
      mapDevices.set(mDNSdevicesObjectWEBUI.deviceName, mDNSdevicesObjectWEBUI.deviceIP4)//map.forEach (myFunction);

      //Save the JSON 
      fs.appendFile('mDNSDevices.json', JSON.stringify(mDNSdevicesObjectWEBUI) + "\r\n", err => {
        if (err) { console.error(err); }
      });

    }//if device is already added then return without saving
    else {
      return
    }

    //record the packet in file
    fs.appendFile('mDNSfile.log', formatDate(new Date()) + validateCommentizeLogs(mDNSdevicesObjectWEBUI.deviceName) + '\n\r', err => {
      if (err) { console.error(err); }
    });

    //display the name at UI
    try { console.log(validateCommentizeLogs(mDNSdevicesObjectWEBUI.deviceName)) } catch (e) { validateCommentizeLogs('New') }

  }
}

//*****************************Default methods for mdns discovery************************ */

//default method for mdns
//main method that runs when response received
mdns.on('response', function (response) {

  //log every response in mDNSfile.log file
  fs.appendFile('mDNSfile.log', formatDate(new Date()) + JSON.stringify(response) + '\n\r', err => {
    if (err) { console.error(err); }
  });

  try {
    if (response.answers !== undefined && response.answers[0] != 'undefined') // response must not be empty and some data must exist
      queryAnswersSmartThing(response);
  } catch (e) {  }

})


//default method for mdns
mdns.on('warning', function (err) { console.log(err.stack) })

//json mdns object
let mDNSdevicesObjectWEBUI = { deviceName: "value", deviceIP4: " ", deviceIP6: " ", deviceMac: " ", deviceModel: " " };

//mdns method for query
mdns.on('query', function (query) {

  query.questions.forEach(function (q) {
    console.log(q)
    if (q.type === 'A' && q.name === '_smartthings._tcp._site') {
      // send an A-record response for example.local
      mdns.respond({
        answers: [{
          name: '_smartthings._tcp._site',
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
    name: '_smartthings._tcp._site',
    type: 'A'
  }]
})
