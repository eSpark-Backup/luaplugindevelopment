var mdns = require('./')()
let mDNSLocalModules = require("./mDNSLocalModules.js")

const fs = require('fs');
let mapDevices = new Map();

//Specific function for PhilipsHue Device
function queryAnswersPhilipsHue(checkQueryResponseAnswers) {

  let responseJsonStr = JSON.stringify(checkQueryResponseAnswers);

  var srchResponse = responseJsonStr.toLocaleLowerCase()

  //Only PhilipsHue device will be filtered that data found in Answers packet of response
  //Philips hue - xxxx
  if (srchResponse.includes('Philips-hue')) {

    try { mDNSdevicesObjectWEBUI.deviceName = mDNSLocalModules.validateDeviceNamePhilipsHue(srchResponse);} catch (e) { }
    try { mDNSdevicesObjectWEBUI.deviceModel = mDNSdevicesObjectWEBUI.deviceName.replace('Philips hue - /gi',''); } catch (e) { mDNSdevicesObjectWEBUI.deviceModel = ''; }
    try { mDNSdevicesObjectWEBUI.deviceIP4 = mDNSLocalModules.validateIPv4(responseJsonStr) } catch (e) { }
    try { mDNSdevicesObjectWEBUI.deviceMac = mDNSLocalModules.validateMacAddress(responseJsonStr) } catch (e) { }
    try { mDNSdevicesObjectWEBUI.deviceIP6 = mDNSLocalModules.validateIPv6(responseJsonStr) } catch (e) { }

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
    fs.appendFile('mDNSfile.log', mDNSLocalModules.formatDate(new Date()) + mDNSLocalModules.validateCommentizeLogs(mDNSdevicesObjectWEBUI.deviceName) + '\n\r', err => {
      if (err) { console.error(err); }
    });

    //display the name at UI
    try { console.log(mDNSLocalModules.validateCommentizeLogs(mDNSdevicesObjectWEBUI.deviceName)) } catch (e) { mDNSLocalModules.validateCommentizeLogs('New') }

  }
}

//*****************************Default methods for mdns discovery************************ */

//default method for mdns
//main method that runs when response received
mdns.on('response', function (response) {

  //log every response in mDNSfile.log file
  fs.appendFile('mDNSfile.log', mDNSLocalModules.formatDate(new Date()) + JSON.stringify(response) + '\n\r', err => {
    if (err) { console.error(err); }
  });

  //https://www.home-assistant.io/integrations/homekit_controller/
  // PhilipsHuey device found on Answers array from response
  //{'host': '192.168.17.5',  'hostname': 'Philips-hue.local.',  'name': 'Philips hue - xxxx',  'port': 8080,  'properties': {'c#': '21','ci': '2','ff': '1','id': 'AA:BB:CC:DD:EE:FF','md': 'BSB002','pv': '1.1','s#': '1','sf': '0'}}

  try {
    if (response.answers !== undefined && response.answers[0] != 'undefined') // response must not be empty and some data must exist
      queryAnswersPhilipsHue(response);
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
