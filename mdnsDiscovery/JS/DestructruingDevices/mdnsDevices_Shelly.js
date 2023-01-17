//import { isString } from './mDNSLocalModules.js';
var mdns = require('./')()
let mDNSLocalModules = require("./mDNSLocalModules.js")

const fs = require('fs');
let mapDevices = new Map();

//default method for mdns
mdns.on('warning', function (err) {  console.log(err.stack)})

  //json mdns object
  let mDNSdevicesObject = {    deviceName: "value",    deviceType: " ",    deviceIP4: " ",    deviceData: " "  };
  
  //json mdns object
  let mDNSdevicesObjectWEBUI = {    deviceName: "value",    deviceIP4: " " , deviceModel:" " };

//default method for mdns
//main method that runs when response received
mdns.on('response', function (response) {

  fs.appendFile('mDNSfile.log', mDNSLocalModules.formatDate(new Date()) + JSON.stringify(response) + '\n\r', err => {
    if (err) { console.error(err); }
  });

  // Shelly device found on Answers array from response
  //{"id":0,"type":"response","flags":1152,"flag_qr":true,"opcode":"QUERY","flag_aa":true,"flag_tc":false,"flag_rd":false,"flag_ra":true,"flag_z":false,"flag_ad":false,"flag_cd":false,"rcode":"NOERROR","questions":[],"answers":[{"name":"_services._dns-sd._udp.local","type":"PTR","ttl":4500,"class":"IN","flush":false,"data":"_http._tcp.local"},{"name":"_http._tcp.local","type":"PTR","ttl":4500,"class":"IN","flush":false,"data":"shelly1-8CAAB56E1209._http._tcp.local"},{"name":"shelly1-8CAAB56E1209._http._tcp.local","type":"SRV","ttl":120,"class":"IN","flush":true,"data":{"priority":0,"weight":0,"port":80,"target":"shelly1-8CAAB56E1209.local"}},{"name":"shelly1-8CAAB56E1209._http._tcp.local","type":"TXT","ttl":120,"class":"IN","flush":true,"data":[{"type":"Buffer","data":[105,100,61,115,104,101,108,108,121,49,45,56,67,65,65,66,53,54,69,49,50,48,57]},{"type":"Buffer","data":[97,114,99,104,61,101,115,112,56,50,54,54]},{"type":"Buffer","data":[97,112,112,61,115,119,105,116,99,104,49]},{"type":"Buffer","data":[102,119,95,118,101,114,115,105,111,110,61,49,46,48]},{"type":"Buffer","data":[102,119,95,105,100,61,50,48,50,50,49,48,50,55,45,48,57,49,52,50,55,47,118,49,46,49,50,46,49,45,103,97,57,49,49,55,100,51]},{"type":"Buffer","data":[100,105,115,99,111,118,101,114,97,98,108,101,61,102,97,108,115,101]}]},{"name":"shelly1-8CAAB56E1209.local","type":"A","ttl":120,"class":"IN","flush":true,"data":"10.100.132.58"},{"name":"shelly1-8CAAB56E1209.local","type":"NSEC","ttl":120,"class":"IN","flush":true,"data":{"nextDomain":"shelly1-8CAAB56E1209.local","rrtypes":["A"]}}],"authorities":[],"additionals":[]}
  // "name":"shelly1-8CAAB56E1209.local", "type":"A", "ttl":120,  "class":"IN", "flush":true, "data":"10.100.132.58"

  try {
    if (response.answers !== undefined && response.answers[cntr] != 'undefined') // response must not be empty and some data must exist
      queryAnswersShelly(response);
  } catch (e) {
  }

})

//Specific function for Shelly Device
function queryAnswersShelly(checkQueryResponseAnswers) {

  //Only Shelly device will be filtered
  if (checkQueryResponseAnswers.answers[cntr].name.toLocaleLowerCase().includes('shelly')) {
    var cntr = 0

    //display the name at UI
    try { console.log('********************************************' + checkQueryResponseAnswers.answers[cntr].name + ' Device Found********************************************') } catch (e) { console.log('********************************************New Device Found********************************************') }

    //record the packet in file
    fs.appendFile('mDNSfile.log', mDNSLocalModules.formatDate(new Date()) + '********************************************New Device Found********************************************' + '\n\r', err => {
      if (err) { console.error(err); }
    });

    //parse all the records in response including "type":"PTR","TXT","SRV","AAAA", and all in this response
    while (true) {
      mDNSdevicesObject.deviceName = checkQueryResponseAnswers.answers[cntr].name;
      mDNSdevicesObject.deviceType = checkQueryResponseAnswers.answers[cntr].type;
      mDNSdevicesObject.deviceIP4 = ""

      //check if IPv4 Exist and is Proper IPv4 address
      if (mDNSLocalModules.isString(checkQueryResponseAnswers.answers[cntr].data) && /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(checkQueryResponseAnswers.answers[cntr].data)) {
        mDNSdevicesObject.deviceIP4 = checkQueryResponseAnswers.answers[cntr].data;
      }

      mDNSdevicesObject.deviceData = checkQueryResponseAnswers.answers[cntr].ttl;

      //if data found store in JSON format
      if (mDNSdevicesObject.deviceIP4.length > 1) {

        mDNSdevicesObjectWEBUI.deviceName = mDNSdevicesObject.deviceName
        //shelly1-8CAAB56E1209
        mDNSdevicesObjectWEBUI.deviceModel = mDNSdevicesObject.deviceName.substring(mDNSdevicesObject.deviceName.indexOf('-')+1);        
        mDNSdevicesObjectWEBUI.deviceIP4 = mDNSdevicesObject.deviceIP4

        //Dictionary mustnot have the same Attribute already
        if (!mapDevices.has(mDNSdevicesObject.deviceName)) {
          console.log('********************************************1111111111111111111111111111111111111111111111111111111111111********************************************************', mDNSdevicesObjectWEBUI);

          //Save the dictionary
          mapDevices.set(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceIP4)//map.forEach (myFunction);

          //Save the JSON 
          fs.appendFile('mDNSDevices.json', JSON.stringify(mDNSdevicesObjectWEBUI) + "\r\n", err => {
            if (err) { console.error(err); }
          });

        }

      }

      cntr = cntr + 1
      //Prints all the packet data onConsole
      console.log(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceType, mDNSdevicesObject.deviceIP4, mDNSdevicesObject.deviceData)
    }
  }

}

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
