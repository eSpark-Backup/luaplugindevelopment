var mdns = require('./')()
let mDNSLocalModules = require("./mDNSLocalModules.js")

const fs = require('fs');
let mapDevices = new Map();

//Specific function for Google Device
function queryAnswersGoogle(checkQueryResponseAnswers) {

  let responseJsonStr = JSON.stringify(checkQueryResponseAnswers);

  var srchResponse = responseJsonStr.toLocaleLowerCase()

  //Only Google device will be filtered that data found in Answers packet of response
  if (srchResponse.includes('Google-Home-Mini')) {

    // Google-Home-Mini-3c8bbcf90b85bf733ab898b6c08a21c5._googlecast._tcp.local
    try { mDNSdevicesObjectWEBUI.deviceName = mDNSLocalModules.validateDeviceNameGoogleMini(srchResponse);} catch (e) { }
    try { mDNSdevicesObjectWEBUI.deviceModel = mDNSdevicesObjectWEBUI.deviceName.substring(0,mDNSdevicesObjectWEBUI.deviceName.indexOf('.')).replace('Google-Home-Mini-/gi',''); } catch (e) { mDNSdevicesObjectWEBUI.deviceModel = ''; }
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

  //log every response in mDNSfile.log file
  fs.appendFile('mDNSfile.log', mDNSLocalModules.formatDate(new Date()) + JSON.stringify(response) + '\n\r', err => {
    if (err) { console.error(err); }
  });

  // GoogleHome device found on Answers array from response
  //{"id":0,"type":"response","flags":1024,"flag_qr":true,"opcode":"QUERY","flag_aa":true,"flag_tc":false,"flag_rd":false,"flag_ra":false,"flag_z":false,"flag_ad":false,"flag_cd":false,"rcode":"NOERROR","questions":[],"answers":[{"name":"Google-Home-Mini-3c8bbcf90b85bf733ab898b6c08a21c5._googlecast._tcp.local","type":"TXT","ttl":4500,"class":"IN","flush":true,"data":[{"type":"Buffer","data":[105,100,61,51,99,56,98,98,99,102,57,48,98,56,53,98,102,55,51,51,97,98,56,57,56,98,54,99,48,56,97,50,49,99,53]},{"type":"Buffer","data":[99,100,61,54,55,48,66,67,48,70,69,56,52,69,67,49,55,57,70,56,51,51,57,50,54,65,69,69,56,70,70,67,55,66,66]},{"type":"Buffer","data":[114,109,61]},{"type":"Buffer","data":[118,101,61,48,53]},{"type":"Buffer","data":[109,100,61,71,111,111,103,108,101,32,72,111,109,101,32,77,105,110,105]},{"type":"Buffer","data":[105,99,61,47,115,101,116,117,112,47,105,99,111,110,46,112,110,103]},{"type":"Buffer","data":[102,110,61,79,102,105,115]},{"type":"Buffer","data":[99,97,61,49,57,57,49,55,50]},{"type":"Buffer","data":[115,116,61,48]},{"type":"Buffer","data":[98,115,61,70,65,56,70,67,65,53,69,67,66,55,67]},{"type":"Buffer","data":[110,102,61,49]},{"type":"Buffer","data":[114,115,61]}]}],"authorities":[],"additionals":[]}
  // Google-Home-Mini-3c8bbcf90b85bf733ab898b6c08a21c5._googlecast._tcp.local
  try {
    if (response.answers !== undefined && response.answers[0] != 'undefined') // response must not be empty and some data must exist
      queryAnswersGoogle(response);
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
