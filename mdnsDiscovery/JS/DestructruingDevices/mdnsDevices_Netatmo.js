var mdns = require('./')()
let mDNSLocalModules = require("./mDNSLocalModules.js")

const fs = require('fs');
let mapDevices = new Map();

//Specific function for Netatmo Device
function queryAnswersNetatmo(checkQueryResponseAnswers) {

  let responseJsonStr = JSON.stringify(checkQueryResponseAnswers);

  var srchResponse = responseJsonStr.toLocaleLowerCase()

  //https://forum.openwrt.org/t/netatmo-homekit-native-devices-not-able-to-update-ios-home-app-when-isolated-but-work-online-using-netamo-app/149133
  //Only netatmo device will be filtered that data found in Answers packet of response
  //Netatmo\032Relay\032(2)._hap._tcp               TXT     "c#=9" "s#=1" "ff=1" "sf=0" "pv=1.1" "md=Netatmo Relay" "id=xx:xxxx:30:BF:3C" "na_tkn=cba8" "ci=2" "sh=LJ/KDg=="
  if (srchResponse.includes('netatmo')) {

    try { mDNSdevicesObjectWEBUI.deviceName = mDNSLocalModules.validateDeviceNameNetatmo(srchResponse);} catch (e) { }
    try { mDNSdevicesObjectWEBUI.deviceModel = mDNSdevicesObjectWEBUI.deviceName.replace('Netatmo ',''); } catch (e) { mDNSdevicesObjectWEBUI.deviceModel = ''; }
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

  // netatmo device found on Answers array from response
  ////Netatmo\032Relay\032(2)._hap._tcp               TXT     "c#=9" "s#=1" "ff=1" "sf=0" "pv=1.1" "md=Netatmo Relay" "id=xx:xxxx:30:BF:3C" "na_tkn=cba8" "ci=2" "sh=LJ/KDg=="
    try {
    if (response.answers !== undefined && response.answers[0] != 'undefined') // response must not be empty and some data must exist
      queryAnswersNetatmo(response);
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
