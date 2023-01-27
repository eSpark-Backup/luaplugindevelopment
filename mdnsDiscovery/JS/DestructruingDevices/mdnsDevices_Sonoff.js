var mdns = require('.')()
let mDNSLocalModules = require("./mDNSLocalModules.js")

const fs = require('fs');
let mapDevices = new Map();

//Specific function for Sonoff Device
function queryAnswersSonoff(checkQueryResponseAnswers) {
  
  let responseJsonStr = JSON.stringify(checkQueryResponseAnswers);
  
  var srchResponse = responseJsonStr.toLocaleLowerCase()

  //sonoff.tech/diy-developer/#4
  //Only Sonoff device will be filtered that data found in Answers packet of response
  if (srchResponse.includes('ewelink')) {

     //Format: eWeLink_[Device ID]	eWeLink_10000000d0
    try { mDNSdevicesObjectWEBUI.deviceName = mDNSLocalModules.validateDeviceNameSonoff(srchResponse);} catch (e) { }
    try { mDNSdevicesObjectWEBUI.deviceModel = mDNSdevicesObjectWEBUI.deviceName.substring(mDNSdevicesObjectWEBUI.deviceName.indexOf('_') + 1); } catch (e) { mDNSdevicesObjectWEBUI.deviceModel = ''; }
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
    fs.appendFile('mDNSfile.log', mDNSLocalModules.formatDate(new Date()) + validateCommentizeLogs(mDNSdevicesObjectWEBUI.deviceName) + '\n\r', err => {
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


//Search in the LAN for all devices with the service type _ewelink._tcp through the DNS PTR record.
//Get the Hostname and Port of device service via parsing out the device DNS SRV record. (The default port is 8081)
//Get device IP address via DNS A record or by other means.
//Get the info of “device ID”, “Service Type”, “device API interface version” and “device information” via parsing out the device DNS TXT Record.

  //log every response in mDNSfile.log file
  fs.appendFile('mDNSfile.log', mDNSLocalModules.formatDate(new Date()) + JSON.stringify(response) + '\n\r', err => {
    if (err) { console.error(err); }
  });

  //_ewelink._tcp
  try {
    if (response.answers !== undefined && response.answers[0] != 'undefined') // response must not be empty and some data must exist
      queryAnswersSonoff(response);
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
    if (q.type === 'A' && q.name === '_ewelink._tcp') {
      // send an A-record response for example.local
      mdns.respond({
        answers: [{
          name: '_ewelink._tcp',
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
    name: '_ewelink._tcp',
    type: 'A'
  }]
})
