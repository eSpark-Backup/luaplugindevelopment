var mdns = require('./')()
const fs = require('fs');
let mapDevices = new Map();

function isString(x) {
  return Object.prototype.toString.call(x) === "[object String]"
}

//supporting datetime methods
function padTo2Digits(num) {
  return num.toString().padStart(2, '0');
}

//supporting datetime methods
function formatDate(date) {
  return (
    [
      date.getFullYear(),
      padTo2Digits(date.getMonth() + 1),
      padTo2Digits(date.getDate()),
    ].join('-') +
    ' ' +
    [
      padTo2Digits(date.getHours()),
      padTo2Digits(date.getMinutes()),
      padTo2Digits(date.getSeconds()),
    ].join(':')
  );
}

//json mdns object
let mDNSdevicesObject = {
  deviceName: "value",
  deviceType: " ",
  deviceIP4: " ",
  deviceData: " "
};

//json mdns object
let mDNSdevicesObjectWEBUI = {
  deviceName: "value",
  deviceIP4: " "
};

//default method for mdns
mdns.on('warning', function (err) {
  console.log(err.stack)
})

//default method for mdns
//main method that runs when response received
mdns.on('response', function (response) {

  fs.appendFile('mDNSfile.log', formatDate(new Date()) + JSON.stringify(response) + '\n\r', err => {
    if (err) { console.error(err); }
  });

  // Shelly device on answers array
  //{"id":0,"type":"response","flags":1152,"flag_qr":true,"opcode":"QUERY","flag_aa":true,"flag_tc":false,"flag_rd":false,"flag_ra":true,"flag_z":false,"flag_ad":false,"flag_cd":false,"rcode":"NOERROR","questions":[],"answers":[{"name":"_services._dns-sd._udp.local","type":"PTR","ttl":4500,"class":"IN","flush":false,"data":"_http._tcp.local"},{"name":"_http._tcp.local","type":"PTR","ttl":4500,"class":"IN","flush":false,"data":"shelly1-8CAAB56E1209._http._tcp.local"},{"name":"shelly1-8CAAB56E1209._http._tcp.local","type":"SRV","ttl":120,"class":"IN","flush":true,"data":{"priority":0,"weight":0,"port":80,"target":"shelly1-8CAAB56E1209.local"}},{"name":"shelly1-8CAAB56E1209._http._tcp.local","type":"TXT","ttl":120,"class":"IN","flush":true,"data":[{"type":"Buffer","data":[105,100,61,115,104,101,108,108,121,49,45,56,67,65,65,66,53,54,69,49,50,48,57]},{"type":"Buffer","data":[97,114,99,104,61,101,115,112,56,50,54,54]},{"type":"Buffer","data":[97,112,112,61,115,119,105,116,99,104,49]},{"type":"Buffer","data":[102,119,95,118,101,114,115,105,111,110,61,49,46,48]},{"type":"Buffer","data":[102,119,95,105,100,61,50,48,50,50,49,48,50,55,45,48,57,49,52,50,55,47,118,49,46,49,50,46,49,45,103,97,57,49,49,55,100,51]},{"type":"Buffer","data":[100,105,115,99,111,118,101,114,97,98,108,101,61,102,97,108,115,101]}]},{"name":"shelly1-8CAAB56E1209.local","type":"A","ttl":120,"class":"IN","flush":true,"data":"10.100.132.58"},{"name":"shelly1-8CAAB56E1209.local","type":"NSEC","ttl":120,"class":"IN","flush":true,"data":{"nextDomain":"shelly1-8CAAB56E1209.local","rrtypes":["A"]}}],"authorities":[],"additionals":[]}
  // "name":"shelly1-8CAAB56E1209.local", "type":"A", "ttl":120,  "class":"IN", "flush":true, "data":"10.100.132.58"
  try {
    if (checkQueryResponseAnswers.answers !== undefined && checkQueryResponseAnswers.answers[cntr] != 'undefined') // response must not be empty and some data must exist
      queryAnswersShelly(response);
  } catch (e) {
  }

  //{"id":0,"type":"response","flags":1024,"flag_qr":true,"opcode":"QUERY","flag_aa":true,"flag_tc":false,"flag_rd":false,"flag_ra":false,"flag_z":false,"flag_ad":false,"flag_cd":false,"rcode":"NOERROR","questions":[],"answers":[{"name":"_spotify-connect._tcp.local","type":"PTR","ttl":4500,"class":"IN","flush":false,"data":"sonos48A6B887691A._spotify-connect._tcp.local"}],"authorities":[],"additionals":[{"name":"sonos48A6B887691A._spotify-connect._tcp.local","type":"TXT","ttl":4500,"class":"IN","flush":true,"data":[{"type":"Buffer","data":[86,69,82,83,73,79,78,61,49]},{"type":"Buffer","data":[67,80,97,116,104,61,47,115,112,111,116,105,102,121,122,99]}]},{"name":"sonos48A6B887691A._spotify-connect._tcp.local","type":"SRV","ttl":120,"class":"IN","flush":true,"data":{"priority":0,"weight":0,"port":1400,"target":"Sonos-48A6B887691A.local"}},{"name":"Sonos-48A6B887691A.local","type":"A","ttl":120,"class":"IN","flush":true,"data":"10.100.132.36"},{"name":"Sonos-48A6B887691A.local","type":"AAAA","ttl":120,"class":"IN","flush":true,"data":"fe80::4aa6:b8ff:fe87:691a"},{"name":"sonos48A6B887691A._spotify-connect._tcp.local","type":"NSEC","ttl":4500,"class":"IN","flush":true,"data":{"nextDomain":"sonos48A6B887691A._spotify-connect._tcp.local","rrtypes":["TXT","SRV"]}},{"name":"Sonos-48A6B887691A.local","type":"NSEC","ttl":120,"class":"IN","flush":true,"data":{"nextDomain":"Sonos-48A6B887691A.local","rrtypes":["A","AAAA"]}}]}
  //"name":"Sonos-48A6B887691A.local","type":"A","ttl":120,"class":"IN","flush":true,"data":"10.100.132.36"
  // Sonos
  try {

    if (checkQueryResponseAdditionals.additionals !== undefined && checkQueryResponseAnswers.additionals[cntr] != 'undefined')// response must not be empty and some data must exist      
      queryAdditionalsSonos(response);
  } catch (e) {
  }


  // Wemo
  try {

    if (checkQueryResponseAnswers.answers !== undefined && checkQueryResponseAnswers.answers[cntr] != 'undefined')// response must not be empty and some data must exist
      queryAnswersWemo(response);
  } catch (e) {
  }


  // Hikvision Camera
  try {

    if (checkQueryResponseAnswers.answers !== undefined && checkQueryResponseAnswers.answers[cntr] != 'undefined')// response must not be empty and some data must exist
      queryAnswersHikvision(response);
  } catch (e) {
  }

  // netatmo
  try {

    if (checkQueryResponseAnswers.answers !== undefined && checkQueryResponseAnswers.answers[cntr] != 'undefined')// response must not be empty and some data must exist
      queryAnswersNetatmo(response);
  } catch (e) {
  }

  // smartthings
  try {

    if (checkQueryResponseAnswers.answers !== undefined && checkQueryResponseAnswers.answers[cntr] != 'undefined')// response must not be empty and some data must exist
      queryAnswersSmartThings(response);
  } catch (e) {
  }

  // Philips HUE
  try {

    if (checkQueryResponseAnswers.answers !== undefined && checkQueryResponseAnswers.answers[cntr] != 'undefined')// response must not be empty and some data must exist
      queryAnswersPhilipsHue(response);
  } catch (e) {
  }

  // Horus
  try {

    if (checkQueryResponseAnswers.answers !== undefined && checkQueryResponseAnswers.answers[cntr] != 'undefined')// response must not be empty and some data must exist
      queryAnswersHorus(response);
  } catch (e) {
  }

  //answers query here for All devices
  //queryAnswers(response);

  //additionals query here for All devices
  //queryAdditionals(response);

  //Authorities query here for All devices
  //queryAuthorities(response);


})

//General Method function for Shelly Device
function queryAnswers(checkQueryResponseAnswers) {

  if (checkQueryResponseAnswers.answers !== undefined)
    try {
      var cntr = 0


      if (checkQueryResponseAnswers.answers[cntr] != 'undefined') {
        //if(approvedDevicesList.has(checkQueryResponseAnswers.answers[cntr].name.toLocaleLowerCase()))

        if (checkQueryResponseAnswers.answers[cntr].name.toLocaleLowerCase().includes('shelly') || checkQueryResponseAnswers.answers[cntr].name.toLocaleLowerCase().includes('ezlo') || checkQueryResponseAnswers.answers[cntr].name.toLocaleLowerCase().includes('airplay') || checkQueryResponseAnswers.answers[cntr].name.toLocaleLowerCase().includes('hue') || checkQueryResponseAnswers.answers[cntr].name.toLocaleLowerCase().includes('mi-connect') || checkQueryResponseAnswers.answers[cntr].name.toLocaleLowerCase().includes('apple') || checkQueryResponseAnswers.answers[cntr].name.toLocaleLowerCase().includes('sonos')) {

          try { console.log('********************************************' + checkQueryResponseAnswers.answers[cntr].name + ' Device Found********************************************') } catch (e) { console.log('********************************************New Device Found********************************************') }


          fs.appendFile('mDNSfile.log', formatDate(new Date()) + '********************************************New Device Found********************************************' + '\n\r', err => {
            if (err) { console.error(err); }
          });

          //let mDNSdevicesObject = {
          //  deviceName : " ",
          //  deviceType : " ",
          //  deviceIP4 : " ",
          //  deviceData : " "
          //};

          while (true) {
            //console.log('******* Details'+cntr+' *******', checkQueryResponseAnswers.answers[cntr].name , checkQueryResponseAnswers.answers[cntr].data)

            mDNSdevicesObject.deviceName = checkQueryResponseAnswers.answers[cntr].name;
            mDNSdevicesObject.deviceType = checkQueryResponseAnswers.answers[cntr].type;
            mDNSdevicesObject.deviceIP4 = ""

            if (isString(checkQueryResponseAnswers.answers[cntr].data) && /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(checkQueryResponseAnswers.answers[cntr].data)) {
              mDNSdevicesObject.deviceIP4 = checkQueryResponseAnswers.answers[cntr].data;
            }

            mDNSdevicesObject.deviceData = checkQueryResponseAnswers.answers[cntr].ttl;

            if (mDNSdevicesObject.deviceIP4.length > 1) {

              mDNSdevicesObjectWEBUI.deviceName = mDNSdevicesObject.deviceName
              mDNSdevicesObjectWEBUI.deviceIP4 = mDNSdevicesObject.deviceIP4

              if (!mapDevices.has(mDNSdevicesObject.deviceName)) {
                console.log('********************************************1111111111111111111111111111111111111111111111111111111111111********************************************************', mDNSdevicesObjectWEBUI);

                mapDevices.set(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceIP4)//map.forEach (myFunction);

                fs.appendFile('mDNSDevices.json', JSON.stringify(mDNSdevicesObjectWEBUI) + "\r\n", err => {
                  if (err) { console.error(err); }
                });


              }

            }

            cntr = cntr + 1
            console.log(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceType, mDNSdevicesObject.deviceIP4, mDNSdevicesObject.deviceData)
          }
        }

      }

    } catch (e) {
    }


}

function queryAdditionals(checkQueryResponseAdditionals) {

  if (checkQueryResponseAdditionals.additionals !== undefined)
    try {
      cntr = 0


      if (checkQueryResponseAdditionals.additionals[cntr] != 'undefined') {


        //if(approvedDevicesList.has(checkQueryResponseAdditionals.additionals[cntr].name.toLocaleLowerCase()))

        if (checkQueryResponseAdditionals.additionals[cntr].name.toLocaleLowerCase().includes('shelly') || checkQueryResponseAdditionals.additionals[cntr].name.toLocaleLowerCase().includes('ezlo') || checkQueryResponseAdditionals.additionals[cntr].name.toLocaleLowerCase().includes('airplay') || checkQueryResponseAdditionals.additionals[cntr].name.toLocaleLowerCase().includes('hue') || checkQueryResponseAdditionals.additionals[cntr].name.toLocaleLowerCase().includes('mi-connect') || checkQueryResponseAdditionals.additionals[cntr].name.toLocaleLowerCase().includes('apple') || checkQueryResponseAdditionals.additionals[cntr].name.toLocaleLowerCase().includes('sonos')) {
          try { console.log('********************************************' + checkQueryResponseAdditionals.additionals[cntr].name + ' Device Found********************************************') } catch (e) { console.log('********************************************New Device Found********************************************') }

          fs.appendFile('mDNSfile.log', formatDate(new Date()) + JSON.stringify(response) + '\n\r', err => {
            if (err) { console.error(err); }
          });

          while (true) {

            mDNSdevicesObject.deviceName = checkQueryResponseAdditionals.additionals[cntr].name;
            mDNSdevicesObject.deviceType = checkQueryResponseAdditionals.additionals[cntr].type;
            mDNSdevicesObject.deviceIP4 = ""

            if (isString(checkQueryResponseAdditionals.additionals[cntr].data) && /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(checkQueryResponseAdditionals.additionals[cntr].data)) {
              mDNSdevicesObject.deviceIP4 = checkQueryResponseAdditionals.additionals[cntr].data;
            }

            mDNSdevicesObject.deviceData = checkQueryResponseAdditionals.additionals[cntr].ttl;


            if (mDNSdevicesObject.deviceIP4.length > 1) {

              mDNSdevicesObjectWEBUI.deviceName = mDNSdevicesObject.deviceName
              mDNSdevicesObjectWEBUI.deviceIP4 = mDNSdevicesObject.deviceIP4

              if (!mapDevices.has(mDNSdevicesObject.deviceName)) {

                console.log('********************************************2222222222222222222222222222222222222222222222222222222********************************************************', mDNSdevicesObjectWEBUI);

                mapDevices.set(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceIP4)

                fs.appendFile('mDNSDevices.json', JSON.stringify(mDNSdevicesObjectWEBUI) + "\r\n", err => {
                  if (err) { console.error(err); }
                });


              }
            }
            cntr = cntr + 1
            console.log(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceType, mDNSdevicesObject.deviceIP4, mDNSdevicesObject.deviceData)

          }
        }
      }
    } catch (e) {
      return
    }
}


function queryAuthorities(checkQueryResponseAuthorities) {

  return
}

//Specific function for Shelly Device
function queryAnswersShelly(checkQueryResponseAnswers) {

  if (checkQueryResponseAnswers.answers[cntr].name.toLocaleLowerCase().includes('shelly')) {
    var cntr = 0
    try { console.log('********************************************' + checkQueryResponseAnswers.answers[cntr].name + ' Device Found********************************************') } catch (e) { console.log('********************************************New Device Found********************************************') }


    fs.appendFile('mDNSfile.log', formatDate(new Date()) + '********************************************New Device Found********************************************' + '\n\r', err => {
      if (err) { console.error(err); }
    });

    while (true) {
      mDNSdevicesObject.deviceName = checkQueryResponseAnswers.answers[cntr].name;
      mDNSdevicesObject.deviceType = checkQueryResponseAnswers.answers[cntr].type;
      mDNSdevicesObject.deviceIP4 = ""

      if (isString(checkQueryResponseAnswers.answers[cntr].data) && /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(checkQueryResponseAnswers.answers[cntr].data)) {
        mDNSdevicesObject.deviceIP4 = checkQueryResponseAnswers.answers[cntr].data;
      }

      mDNSdevicesObject.deviceData = checkQueryResponseAnswers.answers[cntr].ttl;

      if (mDNSdevicesObject.deviceIP4.length > 1) {

        mDNSdevicesObjectWEBUI.deviceName = mDNSdevicesObject.deviceName
        mDNSdevicesObjectWEBUI.deviceIP4 = mDNSdevicesObject.deviceIP4

        if (!mapDevices.has(mDNSdevicesObject.deviceName)) {
          console.log('********************************************1111111111111111111111111111111111111111111111111111111111111********************************************************', mDNSdevicesObjectWEBUI);

          mapDevices.set(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceIP4)//map.forEach (myFunction);

          fs.appendFile('mDNSDevices.json', JSON.stringify(mDNSdevicesObjectWEBUI) + "\r\n", err => {
            if (err) { console.error(err); }
          });


        }

      }

      cntr = cntr + 1
      console.log(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceType, mDNSdevicesObject.deviceIP4, mDNSdevicesObject.deviceData)
    }
  }

}

//Specific function for Hikvision Device
function queryAnswersHikvision(checkQueryResponseAnswers) {

  if (checkQueryResponseAnswers.answers[cntr].name.toLocaleLowerCase().includes('hikvision')) {
    var cntr = 0
    try { console.log('********************************************' + checkQueryResponseAnswers.answers[cntr].name + ' Device Found********************************************') } catch (e) { console.log('********************************************New Device Found********************************************') }


    fs.appendFile('mDNSfile.log', formatDate(new Date()) + '********************************************New Device Found********************************************' + '\n\r', err => {
      if (err) { console.error(err); }
    });

    while (true) {
     mDNSdevicesObject.deviceName = checkQueryResponseAnswers.answers[cntr].name;
      mDNSdevicesObject.deviceType = checkQueryResponseAnswers.answers[cntr].type;
      mDNSdevicesObject.deviceIP4 = ""

      if (isString(checkQueryResponseAnswers.answers[cntr].data) && /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(checkQueryResponseAnswers.answers[cntr].data)) {
        mDNSdevicesObject.deviceIP4 = checkQueryResponseAnswers.answers[cntr].data;
      }

      mDNSdevicesObject.deviceData = checkQueryResponseAnswers.answers[cntr].ttl;

      if (mDNSdevicesObject.deviceIP4.length > 1) {

        mDNSdevicesObjectWEBUI.deviceName = mDNSdevicesObject.deviceName
        mDNSdevicesObjectWEBUI.deviceIP4 = mDNSdevicesObject.deviceIP4

        if (!mapDevices.has(mDNSdevicesObject.deviceName)) {
          console.log('********************************************1111111111111111111111111111111111111111111111111111111111111********************************************************', mDNSdevicesObjectWEBUI);

          mapDevices.set(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceIP4)//map.forEach (myFunction);

          fs.appendFile('mDNSDevices.json', JSON.stringify(mDNSdevicesObjectWEBUI) + "\r\n", err => {
            if (err) { console.error(err); }
          });


        }

      }

      cntr = cntr + 1
      console.log(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceType, mDNSdevicesObject.deviceIP4, mDNSdevicesObject.deviceData)
    }
  }

}
//Specific function for Wemo Device
function queryAnswersWemo(checkQueryResponseAnswers) {

  if (checkQueryResponseAnswers.answers[cntr].name.toLocaleLowerCase().includes('wemo')) {
    var cntr = 0
    try { console.log('********************************************' + checkQueryResponseAnswers.answers[cntr].name + ' Device Found********************************************') } catch (e) { console.log('********************************************New Device Found********************************************') }


    fs.appendFile('mDNSfile.log', formatDate(new Date()) + '********************************************New Device Found********************************************' + '\n\r', err => {
      if (err) { console.error(err); }
    });

     while (true) {
      
      mDNSdevicesObject.deviceName = checkQueryResponseAnswers.answers[cntr].name;
      mDNSdevicesObject.deviceType = checkQueryResponseAnswers.answers[cntr].type;
      mDNSdevicesObject.deviceIP4 = ""

      if (isString(checkQueryResponseAnswers.answers[cntr].data) && /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(checkQueryResponseAnswers.answers[cntr].data)) {
        mDNSdevicesObject.deviceIP4 = checkQueryResponseAnswers.answers[cntr].data;
      }

      mDNSdevicesObject.deviceData = checkQueryResponseAnswers.answers[cntr].ttl;

      if (mDNSdevicesObject.deviceIP4.length > 1) {

        mDNSdevicesObjectWEBUI.deviceName = mDNSdevicesObject.deviceName
        mDNSdevicesObjectWEBUI.deviceIP4 = mDNSdevicesObject.deviceIP4

        if (!mapDevices.has(mDNSdevicesObject.deviceName)) {
          console.log('********************************************1111111111111111111111111111111111111111111111111111111111111********************************************************', mDNSdevicesObjectWEBUI);

          mapDevices.set(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceIP4)//map.forEach (myFunction);

          fs.appendFile('mDNSDevices.json', JSON.stringify(mDNSdevicesObjectWEBUI) + "\r\n", err => {
            if (err) { console.error(err); }
          });


        }

      }

      cntr = cntr + 1
      console.log(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceType, mDNSdevicesObject.deviceIP4, mDNSdevicesObject.deviceData)
    }
  }

}

//Specific function for Netatmo Device
function queryAnswersNetatmo(checkQueryResponseAnswers) {

  if (checkQueryResponseAnswers.answers[cntr].name.toLocaleLowerCase().includes('netatmo')) {
    var cntr = 0
    try { console.log('********************************************' + checkQueryResponseAnswers.answers[cntr].name + ' Device Found********************************************') } catch (e) { console.log('********************************************New Device Found********************************************') }


    fs.appendFile('mDNSfile.log', formatDate(new Date()) + '********************************************New Device Found********************************************' + '\n\r', err => {
      if (err) { console.error(err); }
    });


    while (true) {
 
      mDNSdevicesObject.deviceName = checkQueryResponseAnswers.answers[cntr].name;
      mDNSdevicesObject.deviceType = checkQueryResponseAnswers.answers[cntr].type;
      mDNSdevicesObject.deviceIP4 = ""

      if (isString(checkQueryResponseAnswers.answers[cntr].data) && /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(checkQueryResponseAnswers.answers[cntr].data)) {
        mDNSdevicesObject.deviceIP4 = checkQueryResponseAnswers.answers[cntr].data;
      }

      mDNSdevicesObject.deviceData = checkQueryResponseAnswers.answers[cntr].ttl;

      if (mDNSdevicesObject.deviceIP4.length > 1) {

        mDNSdevicesObjectWEBUI.deviceName = mDNSdevicesObject.deviceName
        mDNSdevicesObjectWEBUI.deviceIP4 = mDNSdevicesObject.deviceIP4

        if (!mapDevices.has(mDNSdevicesObject.deviceName)) {
          console.log('********************************************1111111111111111111111111111111111111111111111111111111111111********************************************************', mDNSdevicesObjectWEBUI);

          mapDevices.set(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceIP4)//map.forEach (myFunction);

          fs.appendFile('mDNSDevices.json', JSON.stringify(mDNSdevicesObjectWEBUI) + "\r\n", err => {
            if (err) { console.error(err); }
          });


        }

      }

      cntr = cntr + 1
      console.log(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceType, mDNSdevicesObject.deviceIP4, mDNSdevicesObject.deviceData)
    }
  }

}

//Specific function for Philips/Hue Device
function queryAnswersPhilipsHue(checkQueryResponseAnswers) {

  if (checkQueryResponseAnswers.answers[cntr].name.toLocaleLowerCase().includes('philips') || checkQueryResponseAnswers.answers[cntr].name.toLocaleLowerCase().includes('hue')) {
    var cntr = 0
    try { console.log('********************************************' + checkQueryResponseAnswers.answers[cntr].name + ' Device Found********************************************') } catch (e) { console.log('********************************************New Device Found********************************************') }


    fs.appendFile('mDNSfile.log', formatDate(new Date()) + '********************************************New Device Found********************************************' + '\n\r', err => {
      if (err) { console.error(err); }
    });

    while (true) {
   
      mDNSdevicesObject.deviceName = checkQueryResponseAnswers.answers[cntr].name;
      mDNSdevicesObject.deviceType = checkQueryResponseAnswers.answers[cntr].type;
      mDNSdevicesObject.deviceIP4 = ""

      if (isString(checkQueryResponseAnswers.answers[cntr].data) && /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(checkQueryResponseAnswers.answers[cntr].data)) {
        mDNSdevicesObject.deviceIP4 = checkQueryResponseAnswers.answers[cntr].data;
      }

      mDNSdevicesObject.deviceData = checkQueryResponseAnswers.answers[cntr].ttl;

      if (mDNSdevicesObject.deviceIP4.length > 1) {

        mDNSdevicesObjectWEBUI.deviceName = mDNSdevicesObject.deviceName
        mDNSdevicesObjectWEBUI.deviceIP4 = mDNSdevicesObject.deviceIP4

        if (!mapDevices.has(mDNSdevicesObject.deviceName)) {
          console.log('********************************************1111111111111111111111111111111111111111111111111111111111111********************************************************', mDNSdevicesObjectWEBUI);

          mapDevices.set(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceIP4)//map.forEach (myFunction);

          fs.appendFile('mDNSDevices.json', JSON.stringify(mDNSdevicesObjectWEBUI) + "\r\n", err => {
            if (err) { console.error(err); }
          });


        }

      }

      cntr = cntr + 1
      console.log(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceType, mDNSdevicesObject.deviceIP4, mDNSdevicesObject.deviceData)
    }
  }

}

//Specific function for SmartThings Device
function queryAnswersSmartThings(checkQueryResponseAnswers) {

  if (checkQueryResponseAnswers.answers[cntr].name.toLocaleLowerCase().includes('smart')) {
    var cntr = 0
    try { console.log('********************************************' + checkQueryResponseAnswers.answers[cntr].name + ' Device Found********************************************') } catch (e) { console.log('********************************************New Device Found********************************************') }


    fs.appendFile('mDNSfile.log', formatDate(new Date()) + '********************************************New Device Found********************************************' + '\n\r', err => {
      if (err) { console.error(err); }
    });

 
    while (true) {
   
      mDNSdevicesObject.deviceName = checkQueryResponseAnswers.answers[cntr].name;
      mDNSdevicesObject.deviceType = checkQueryResponseAnswers.answers[cntr].type;
      mDNSdevicesObject.deviceIP4 = ""

      if (isString(checkQueryResponseAnswers.answers[cntr].data) && /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(checkQueryResponseAnswers.answers[cntr].data)) {
        mDNSdevicesObject.deviceIP4 = checkQueryResponseAnswers.answers[cntr].data;
      }

      mDNSdevicesObject.deviceData = checkQueryResponseAnswers.answers[cntr].ttl;

      if (mDNSdevicesObject.deviceIP4.length > 1) {

        mDNSdevicesObjectWEBUI.deviceName = mDNSdevicesObject.deviceName
        mDNSdevicesObjectWEBUI.deviceIP4 = mDNSdevicesObject.deviceIP4

        if (!mapDevices.has(mDNSdevicesObject.deviceName)) {
          console.log('********************************************1111111111111111111111111111111111111111111111111111111111111********************************************************', mDNSdevicesObjectWEBUI);

          mapDevices.set(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceIP4)//map.forEach (myFunction);

          fs.appendFile('mDNSDevices.json', JSON.stringify(mDNSdevicesObjectWEBUI) + "\r\n", err => {
            if (err) { console.error(err); }
          });


        }

      }

      cntr = cntr + 1
      console.log(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceType, mDNSdevicesObject.deviceIP4, mDNSdevicesObject.deviceData)
    }
  }

}


//Specific function for Horus Device
function queryAnswersHorus(checkQueryResponseAnswers) {

  if (checkQueryResponseAnswers.answers[cntr].name.toLocaleLowerCase().includes('horus')) {
    var cntr = 0
    try { console.log('********************************************' + checkQueryResponseAnswers.answers[cntr].name + ' Device Found********************************************') } catch (e) { console.log('********************************************New Device Found********************************************') }


    fs.appendFile('mDNSfile.log', formatDate(new Date()) + '********************************************New Device Found********************************************' + '\n\r', err => {
      if (err) { console.error(err); }
    });


    while (true) {
      mDNSdevicesObject.deviceName = checkQueryResponseAnswers.answers[cntr].name;
      mDNSdevicesObject.deviceType = checkQueryResponseAnswers.answers[cntr].type;
      mDNSdevicesObject.deviceIP4 = ""

      if (isString(checkQueryResponseAnswers.answers[cntr].data) && /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(checkQueryResponseAnswers.answers[cntr].data)) {
        mDNSdevicesObject.deviceIP4 = checkQueryResponseAnswers.answers[cntr].data;
      }

      mDNSdevicesObject.deviceData = checkQueryResponseAnswers.answers[cntr].ttl;

      if (mDNSdevicesObject.deviceIP4.length > 1) {

        mDNSdevicesObjectWEBUI.deviceName = mDNSdevicesObject.deviceName
        mDNSdevicesObjectWEBUI.deviceIP4 = mDNSdevicesObject.deviceIP4

        if (!mapDevices.has(mDNSdevicesObject.deviceName)) {
          console.log('********************************************1111111111111111111111111111111111111111111111111111111111111********************************************************', mDNSdevicesObjectWEBUI);

          mapDevices.set(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceIP4)//map.forEach (myFunction);

          fs.appendFile('mDNSDevices.json', JSON.stringify(mDNSdevicesObjectWEBUI) + "\r\n", err => {
            if (err) { console.error(err); }
          });


        }

      }

      cntr = cntr + 1
      console.log(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceType, mDNSdevicesObject.deviceIP4, mDNSdevicesObject.deviceData)
    }
  }

}

//Specific function for Sonos/Sonoff Device
function queryAdditionalsSonos(checkQueryResponseAdditionals) {

  if (checkQueryResponseAdditionals.additionals[cntr].name.toLocaleLowerCase().includes('sono')) {
    var cntr = 0
    try { console.log('********************************************' + checkQueryResponseAdditionals.additionals[cntr].name + ' Device Found********************************************') } catch (e) { console.log('********************************************New Device Found********************************************') }

    fs.appendFile('mDNSfile.log', formatDate(new Date()) + JSON.stringify(response) + '\n\r', err => {
      if (err) { console.error(err); }
    });

    while (true) {

      mDNSdevicesObject.deviceName = checkQueryResponseAdditionals.additionals[cntr].name;
      mDNSdevicesObject.deviceType = checkQueryResponseAdditionals.additionals[cntr].type;
      mDNSdevicesObject.deviceIP4 = ""

      if (isString(checkQueryResponseAdditionals.additionals[cntr].data) && /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(checkQueryResponseAdditionals.additionals[cntr].data)) {
        mDNSdevicesObject.deviceIP4 = checkQueryResponseAdditionals.additionals[cntr].data;
      }

      mDNSdevicesObject.deviceData = checkQueryResponseAdditionals.additionals[cntr].ttl;


      if (mDNSdevicesObject.deviceIP4.length > 1) {

        mDNSdevicesObjectWEBUI.deviceName = mDNSdevicesObject.deviceName
        mDNSdevicesObjectWEBUI.deviceIP4 = mDNSdevicesObject.deviceIP4

        if (!mapDevices.has(mDNSdevicesObject.deviceName)) {

          console.log('********************************************2222222222222222222222222222222222222222222222222222222********************************************************', mDNSdevicesObjectWEBUI);

          mapDevices.set(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceIP4)

          fs.appendFile('mDNSDevices.json', JSON.stringify(mDNSdevicesObjectWEBUI) + "\r\n", err => {
            if (err) { console.error(err); }
          });


        }
      }
      cntr = cntr + 1
      console.log(mDNSdevicesObject.deviceName, mDNSdevicesObject.deviceType, mDNSdevicesObject.deviceIP4, mDNSdevicesObject.deviceData)

    }
  }
}


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
