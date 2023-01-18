var mdns = require('./')()
let mDNSLocalModules = require("./mDNSLocalModules.js")

const fs = require('fs');
let mapDevices = new Map();




//Specific function for wemo Device
function queryAnswerswemo(checkQueryResponseAnswers) {

  var cntr = 0
  //console.log('**********************IN queryAnswerswemo**********************')
  //Only wemo device will be filtered that data found in Answers packet of response


    //parse all the records in response including "type":"PTR","TXT","SRV","AAAA",NSEC and all in this response
    while (true) {

  //For wemo Record type must be "A" and name "wemo" exist
    if (checkQueryResponseAnswers.answers[cntr].type=='A' && checkQueryResponseAnswers.answers[cntr].name.toLocaleLowerCase().includes('wemo')) {
      
      
    //display the name at UI
    try { console.log('********************************************' + checkQueryResponseAnswers.answers[cntr].name + ' Device Found********************************************') } catch (e) { console.log('********************************************New Device Found********************************************') }

    //record the packet in file
    fs.appendFile('mDNSfile.log', mDNSLocalModules.formatDate(new Date()) + '********************************************New Device Found********************************************' + '\n\r', err => {
      if (err) { console.error(err); }
    });
      
      mDNSdevicesObject.deviceName = checkQueryResponseAnswers.answers[cntr].name;
      mDNSdevicesObject.deviceType = checkQueryResponseAnswers.answers[cntr].type;
      mDNSdevicesObject.deviceIP4 = ""
      mDNSdevicesObjectWEBUI.deviceModel=""

      //check if IPv4 Exist and is Proper IPv4 address
      if (mDNSLocalModules.validateIPv4(checkQueryResponseAnswers.answers[cntr].data)) {
            mDNSdevicesObject.deviceIP4 = checkQueryResponseAnswers.answers[cntr].data;
      }

      //save data for wemo device in json object
      mDNSdevicesObject.deviceData = checkQueryResponseAnswers.answers[cntr].ttl;

      //if data found store in JSON format
      if (mDNSdevicesObject.deviceIP4.length > 1) {

        mDNSdevicesObjectWEBUI.deviceName = mDNSdevicesObject.deviceName
        
        
        //wemo1-8CAAB56E1209
        try{mDNSdevicesObjectWEBUI.deviceModel = mDNSdevicesObject.deviceName.substring(mDNSdevicesObject.deviceName.indexOf('-')+1);}catch(e){mDNSdevicesObjectWEBUI.deviceModel = mDNSdevicesObject.deviceName;}

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
    }
    
    cntr = cntr + 1 //increment to check other Record Type
    
    //return if all the array parsed
    if(checkQueryResponseAnswers.answers[cntr] == undefined)//|| checkQueryResponseAnswers.answers[cntr] == 'undefined' 
        break;

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

  try {
    if (response.answers !== undefined && response.answers[0] != 'undefined') // response must not be empty and some data must exist
      queryAnswerswemo(response);
  } catch (e) {//console.log('**********************IN catch111111**********************',e)
  }

})


//default method for mdns
mdns.on('warning', function (err) {  console.log(err.stack)})

//json mdns object
let mDNSdevicesObject = {    deviceName: "value",    deviceType: " ",    deviceIP4: " ",    deviceData: " "  };
  
  //json mdns object
let mDNSdevicesObjectWEBUI = {    deviceName: "value",    deviceIP4: " " , deviceModel:" " };

//mdns method for query
mdns.on('query', function (query) {

  query.questions.forEach(function (q) {
    //console.log(q)
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
