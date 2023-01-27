var mdns = require('./')()
let mDNSLocalModules = require("./mDNSLocalModules.js")

const fs = require('fs');
let mapDevices = new Map();

//Specific function for Wemo Device
function queryAnswersWemo(checkQueryResponseAnswers) {

  let responseJsonStr = JSON.stringify(checkQueryResponseAnswers);

  var srchResponse = responseJsonStr.toLocaleLowerCase()

  //Only Wemo device will be filtered that data found in Answers packet of response
  if (srchResponse.includes('wemo')) {

    //  Wemo Dim2G 259._hap._tcp.local
    try { mDNSdevicesObjectWEBUI.deviceName = mDNSLocalModules.validateDeviceNameWemo(srchResponse);} catch (e) { }
    try { mDNSdevicesObjectWEBUI.deviceModel = mDNSdevicesObjectWEBUI.deviceName.substring(0,deviceName.indexOf('.').replace('Wemo ',''));} catch (e) { mDNSdevicesObjectWEBUI.deviceModel = ''; }
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

  // Wemo device found on Answers array from response
  //{"id":0,"type":"response","flags":1024,"flag_qr":true,"opcode":"QUERY","flag_aa":true,"flag_tc":false,"flag_rd":false,"flag_ra":false,"flag_z":false,"flag_ad":false,"flag_cd":false,"rcode":"NOERROR","questions":[],"answers":[{"name":"Wemo Dim2G 259._hap._tcp.local","type":"TXT","ttl":4500,"class":"IN","flush":true,"data":[{"type":"Buffer","data":[99,35,61,49]},{"type":"Buffer","data":[102,102,61,50]},{"type":"Buffer","data":[105,100,61,66,56,58,50,68,58,65,54,58,48,70,58,50,51,58,66,67]},{"type":"Buffer","data":[109,100,61,68,105,109,109,101,114]},{"type":"Buffer","data":[112,118,61,49,46,49]},{"type":"Buffer","data":[115,35,61,49]},{"type":"Buffer","data":[115,102,61,49]},{"type":"Buffer","data":[99,105,61,53]},{"type":"Buffer","data":[115,104,61,65,77,99,74,115,81,61,61]}]},{"name":"_hap._tcp.local","type":"PTR","ttl":4500,"class":"IN","flush":false,"data":"Wemo Dim2G 259._hap._tcp.local"}],"authorities":[],"additionals":[{"name":"Wemo Dim2G 259.local","type":"A","ttl":120,"class":"IN","flush":true,"data":"10.100.132.61"},{"name":"Wemo Dim2G 259.local","type":"AAAA","ttl":120,"class":"IN","flush":true,"data":"fe80::ea9f:80ff:fece:f630"},{"name":"Wemo Dim2G 259._hap._tcp.local","type":"SRV","ttl":120,"class":"IN","flush":true,"data":{"priority":0,"weight":0,"port":63319,"target":"Wemo Dim2G 259.local"}},{"name":"Wemo Dim2G 259.local","type":"NSEC","ttl":120,"class":"IN","flush":true,"data":{"nextDomain":"Wemo Dim2G 259.local","rrtypes":["A","AAAA"]}},{"name":"Wemo Dim2G 259._hap._tcp.local","type":"NSEC","ttl":120,"class":"IN","flush":true,"data":{"nextDomain":"Wemo Dim2G 259._hap._tcp.local","rrtypes":["TXT","SRV"]}}]}
  // Wemo Dim2G 259._hap._tcp.local
  try {
    if (response.answers !== undefined && response.answers[0] != 'undefined') // response must not be empty and some data must exist
      queryAnswersWemo(response);
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
