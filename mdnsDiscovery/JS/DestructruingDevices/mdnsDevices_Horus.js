var mdns = require('./')()
let mDNSLocalModules = require("./mDNSLocalModules.js")

const fs = require('fs');
let mapDevices = new Map();

//Specific function for Horus Device
function queryAnswersHorus(checkQueryResponseAnswers) {
  let responseJsonStr = JSON.stringify(checkQueryResponseAnswers);

  var srchResponse = responseJsonStr.toLocaleLowerCase()

  //Only Horus device will be filtered that data found in Answers packet of response
  if (srchResponse.includes('horus')) {

    try { mDNSdevicesObjectWEBUI.deviceName = mDNSLocalModules.validateDeviceNameHorus(srchResponse);} catch (e) { }
    try { mDNSdevicesObjectWEBUI.deviceModel = mDNSdevicesObjectWEBUI.deviceName; } catch (e) { mDNSdevicesObjectWEBUI.deviceModel = ''; }
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

  // Shelly device found on Answers array from response
  //{"id":0,"type":"response","flags":1152,"flag_qr":true,"opcode":"QUERY","flag_aa":true,"flag_tc":false,"flag_rd":false,"flag_ra":true,"flag_z":false,"flag_ad":false,"flag_cd":false,"rcode":"NOERROR","questions":[],"answers":[{"name":"_services._dns-sd._udp.local","type":"PTR","ttl":4500,"class":"IN","flush":false,"data":"_http._tcp.local"},{"name":"_http._tcp.local","type":"PTR","ttl":4500,"class":"IN","flush":false,"data":"shelly1-8CAAB56E1209._http._tcp.local"},{"name":"shelly1-8CAAB56E1209._http._tcp.local","type":"SRV","ttl":120,"class":"IN","flush":true,"data":{"priority":0,"weight":0,"port":80,"target":"shelly1-8CAAB56E1209.local"}},{"name":"shelly1-8CAAB56E1209._http._tcp.local","type":"TXT","ttl":120,"class":"IN","flush":true,"data":[{"type":"Buffer","data":[105,100,61,115,104,101,108,108,121,49,45,56,67,65,65,66,53,54,69,49,50,48,57]},{"type":"Buffer","data":[97,114,99,104,61,101,115,112,56,50,54,54]},{"type":"Buffer","data":[97,112,112,61,115,119,105,116,99,104,49]},{"type":"Buffer","data":[102,119,95,118,101,114,115,105,111,110,61,49,46,48]},{"type":"Buffer","data":[102,119,95,105,100,61,50,48,50,50,49,48,50,55,45,48,57,49,52,50,55,47,118,49,46,49,50,46,49,45,103,97,57,49,49,55,100,51]},{"type":"Buffer","data":[100,105,115,99,111,118,101,114,97,98,108,101,61,102,97,108,115,101]}]},{"name":"shelly1-8CAAB56E1209.local","type":"A","ttl":120,"class":"IN","flush":true,"data":"10.100.132.58"},{"name":"shelly1-8CAAB56E1209.local","type":"NSEC","ttl":120,"class":"IN","flush":true,"data":{"nextDomain":"shelly1-8CAAB56E1209.local","rrtypes":["A"]}}],"authorities":[],"additionals":[]}
  // "name":"shelly1-8CAAB56E1209.local", "type":"A", "ttl":120,  "class":"IN", "flush":true, "data":"10.100.132.58"

  try {
    if (response.answers !== undefined && response.answers[0] != 'undefined') // response must not be empty and some data must exist
      queryAnswersHorus(response);
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
