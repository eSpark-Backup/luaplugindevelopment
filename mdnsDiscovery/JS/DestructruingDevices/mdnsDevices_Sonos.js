var mdns = require('./')()
let mDNSLocalModules = require("./mDNSLocalModules.js")

const fs = require('fs');
let mapDevices = new Map();

//Specific function for Sonos Device
function queryAnswersSonos(checkQueryResponseAnswers) {
  
  let responseJsonStr = JSON.stringify(checkQueryResponseAnswers);
  
  var srchResponse = responseJsonStr.toLocaleLowerCase()

  //Only Sonos device will be filtered that data found in Answers packet of response
  if (srchResponse.includes('sonos')) {

    //  Sonos1-8CAAB56E1209
    try { mDNSdevicesObjectWEBUI.deviceName = mDNSLocalModules.validateDeviceNameSonos(srchResponse);} catch (e) { }
    try { mDNSdevicesObjectWEBUI.deviceModel = mDNSdevicesObjectWEBUI.deviceName.substring(mDNSdevicesObjectWEBUI.deviceName.indexOf('-') + 1); } catch (e) { mDNSdevicesObjectWEBUI.deviceModel = ''; }
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

  // Sonos device found on Answers array from response
  //{"id":0,"type":"response","flags":1024,"flag_qr":true,"opcode":"QUERY","flag_aa":true,"flag_tc":false,"flag_rd":false,"flag_ra":false,"flag_z":false,"flag_ad":false,"flag_cd":false,"rcode":"NOERROR","questions":[],"answers":[{"name":"_spotify-connect._tcp.local","type":"PTR","ttl":4500,"class":"IN","flush":false,"data":"sonos48A6B887691A._spotify-connect._tcp.local"}],"authorities":[],"additionals":[{"name":"sonos48A6B887691A._spotify-connect._tcp.local","type":"TXT","ttl":4500,"class":"IN","flush":true,"data":[{"type":"Buffer","data":[86,69,82,83,73,79,78,61,49]},{"type":"Buffer","data":[67,80,97,116,104,61,47,115,112,111,116,105,102,121,122,99]}]},{"name":"sonos48A6B887691A._spotify-connect._tcp.local","type":"SRV","ttl":120,"class":"IN","flush":true,"data":{"priority":0,"weight":0,"port":1400,"target":"Sonos-48A6B887691A.local"}},{"name":"Sonos-48A6B887691A.local","type":"A","ttl":120,"class":"IN","flush":true,"data":"10.100.132.36"},{"name":"Sonos-48A6B887691A.local","type":"AAAA","ttl":120,"class":"IN","flush":true,"data":"fe80::4aa6:b8ff:fe87:691a"},{"name":"sonos48A6B887691A._spotify-connect._tcp.local","type":"NSEC","ttl":4500,"class":"IN","flush":true,"data":{"nextDomain":"sonos48A6B887691A._spotify-connect._tcp.local","rrtypes":["TXT","SRV"]}},{"name":"Sonos-48A6B887691A.local","type":"NSEC","ttl":120,"class":"IN","flush":true,"data":{"nextDomain":"Sonos-48A6B887691A.local","rrtypes":["A","AAAA"]}}]}
  //Sonos-48A6B887691A.local
  try {
    if (response.answers !== undefined && response.answers[0] != 'undefined') // response must not be empty and some data must exist
      queryAnswersSonos(response);
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
