var mdns = require('./')()
let mDNSLocalModules = require("./mDNSLocalModules.js")

const fs = require('fs');
let mapDevices = new Map();

//validate the DeviceName
function validateDeviceNameEzlo(devnameData) {
  try{
    //"eZLO 32.1 controller (94010135)._ezlo._tcp.local"
  const regexp = /ezlo[\s*\d*\.A_Za-z0-9\(\)\_]*/gi
  const matches = devnameData.match(regexp)
  
  return Array.from(matches)[0]
  
  }catch(e){return ' '
  }
  
  }

//Specific function for Ezlo Device
function queryAnswersEzlo(checkQueryResponseAnswers) {

  //let responseJsonStr = "{'id':0,'type':'response','flags':1024,'flag_qr':true,'opcode':'QUERY','flag_aa':true,'flag_tc':false,'flag_rd':false,'flag_ra':false,'flag_z':false,'flag_ad':false,'flag_cd':false,'rcode':'NOERROR','questions':[],'answers':[{'name':'eZLO h2_secure.1 controller (92000358)._ezlo._tcp.local','type':'TXT','ttl':4500,'class':'IN','flush':true,'data':[{'type':'Buffer','data':[83,101,114,105,97,108,61,57,50,48,48,48,51,53,56]},{'type':'Buffer','data':[70,105,114,109,119,97,114,101,32,86,101,114,115,105,111,110,61,50,46,48,46,51,55,46,69,70,87,82,45,51,56,56,48,64,119,114,116,95,98,117,105,108,100,46,51]},{'type':'Buffer','data':[86,101,110,100,111,114,61,101,90,76,79]},{'type':'Buffer','data':[72,117,98,32,84,121,112,101,61,104,50,95,115,101,99,117,114,101,46,49]},{'type':'Buffer','data':[77,97,99,61,48,50,58,52,50,58,48,49,58,99,97,58,54,56,58,101,52]}]},{'name':'HUB92000358.local','type':'A','ttl':120,'class':'IN','flush':true,'data':'192.168.18.125'},{'name':'125.18.168.192.in-addr.arpa','type':'PTR','ttl':120,'class':'IN','flush':true,'data':'HUB92000358.local'},{'name':'HUB92000358.local','type':'HINFO','ttl':120,'class':'IN','flush':true,'data':{'cpu':'ARMV7L','os':'LINUX'}},{'name':'eZLO h2_secure.1 controller (92000358)._ezlo._tcp.local','type':'SRV','ttl':120,'class':'IN','flush':true,'data':{'priority':0,'weight':0,'port':17000,'target':'HUB92000358.local'}}],'authorities':[],'additionals':[]}"
  let responseJsonStr = JSON.stringify(checkQueryResponseAnswers);
  var srchResponse = responseJsonStr.toLocaleLowerCase()

  //Only Ezlo device will be filtered that data found in Answers packet of response
  if (srchResponse.includes('ezlo')) {

    try { mDNSdevicesObjectWEBUI.deviceName = validateDeviceNameEzlo(srchResponse);} catch (e) { }
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

  // Ezlo device found on Answers array from response
  //{"id":0,"type":"response","flags":1024,"flag_qr":true,"opcode":"QUERY","flag_aa":true,"flag_tc":false,"flag_rd":false,"flag_ra":false,"flag_z":false,"flag_ad":false,"flag_cd":false,"rcode":"NOERROR","questions":[],"answers":[{"name":"_ezlo._tcp.local","type":"PTR","ttl":4500,"class":"IN","flush":false,"data":"eZLO 32.1 controller (94010135)._ezlo._tcp.local"},{"name":"eZLO 32.1 controller (94010135)._ezlo._tcp.local","type":"SRV","ttl":120,"class":"IN","flush":true,"data":{"priority":0,"weight":0,"port":17000,"target":"HUB94010135.local"}},{"name":"eZLO 32.1 controller (94010135)._ezlo._tcp.local","type":"TXT","ttl":4500,"class":"IN","flush":true,"data":[{"type":"Buffer","data":[72,117,98,32,84,121,112,101,61,51,50,46,49]},{"type":"Buffer","data":[86,101,110,100,111,114,61,101,90,76,79]},{"type":"Buffer","data":[70,105,114,109,119,97,114,101,32,86,101,114,115,105,111,110,61,48,46,56,46,49,53,49,56]},{"type":"Buffer","data":[83,101,114,105,97,108,61,57,52,48,49,48,49,51,53]}]}],"authorities":[],"additionals":[{"name":"HUB94010135.local","type":"A","ttl":120,"class":"IN","flush":true,"data":"10.100.132.54"}]}


  try {
    if (response.answers !== undefined && response.answers[0] != 'undefined') // response must not be empty and some data must exist
    queryAnswersEzlo(response);
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
