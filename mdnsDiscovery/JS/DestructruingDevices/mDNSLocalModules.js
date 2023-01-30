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


//validate the IPV4address
function validateIPv4(ipv4data) {
  
  //if (isString(ipv4data) && /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(ipv4data)) {
    //mDNSdevicesObject.deviceIP4 = checkQueryResponseAnswers.answers[cntr].data;
    try{
    const regexp = '[0-9]\+\\.[0-9]\+\\.[0-9]\+\\.[0-9]+'
    const matches = ipv4data.matchAll(regexp);
    return Array.from(matches)[0][0];
    }catch(e){return ' '
  }
}

//validate the DeviceName
function validateDeviceNameShelly(devnameData) {
      try{
      const regexp = 'shelly\\d-[A-Za-z0-9]*'
      const matches = devnameData.matchAll(regexp)
    
      return Array.from(matches)[0][0]

    }catch(e){return ' '
  }

}

//validate the DeviceName
function validateDeviceNameSonos(devnameData) {
  try{
    //":"sonos48A6B887691A._spotify-connect._tcp.local"},{"name
  const regexp =  /sono[d*A_Za-z0-9\_\.\-]*/gi
  const matches = devnameData.match(regexp)

  return Array.from(matches)[0]

}catch(e){return ' '
}

}

//validate the DeviceName
function validateDeviceNameSonoff(devnameData) {
  try{
    //Format: eWeLink_[Device ID]	eWeLink_10000000d0
  const regexp =  /eWeLink_[d*A_Za-z0-9\_\.\-]*/gi
  const matches = devnameData.match(regexp)

  return Array.from(matches)[0]

}catch(e){return ' '
}

}

//validate the DeviceName
function validateDeviceNameWemo(devnameData) {
  try{//Wemo Dim2G 259._hap.
  const regexp = /wemo[\s*A_Za-z0-9\_\.\-]*/gi
  const matches = devnameData.match(regexp)

  return Array.from(matches)[0]

}catch(e){return ' '
}

}

//validate the DeviceName
function validateDeviceNameSmartThing(devnameData) {
  try{
  const regexp = /smartthings[\s*A_Za-z0-9\_\.\-]*/gi
  const matches = devnameData.match(regexp)

  return Array.from(matches)[0]

}catch(e){return ' '
}

}

//validate the DeviceName
function validateDeviceNamePhilipsHue(devnameData) {
  try{
  const regexp = /Philips\shue\s-[\s*A_Za-z0-9\_\.\-]*/gi
  const matches = devnameData.match(regexp)

  return Array.from(matches)[0]

}catch(e){return ' '
}

}

//validate the DeviceName
function validateDeviceNameNetatmo(devnameData) {
  try{//Netatmo Relay'
  const regexp = /Netatmo\s[\s*A_Za-z0-9\_\.\-]*/gi
  const matches = devnameData.match(regexp)

  return Array.from(matches)[0]

}catch(e){return ' '
}

}


//validate the DeviceName
function validateDeviceNameHorus(devnameData) {
  try{
  const regexp = /horus[\s*A_Za-z0-9\_\.\-]*/gi
  const matches = devnameData.match(regexp)

  return Array.from(matches)[0]

}catch(e){return ' '
}

}

//validate the DeviceName
function validateDeviceNameHikVision(devnameData) {
  try{
  const regexp = /hik[\s*A_Za-z0-9\_\.\-]*/gi
  const matches = devnameData.match(regexp)

  return Array.from(matches)[0]

}catch(e){return ' '
}

}

//validate the DeviceName
function validateDeviceNameGoogleMini(devnameData) {
  try{
    //{"id":0,"type":"response","flags":1024,"flag_qr":true,"opcode":"QUERY","flag_aa":true,"flag_tc":false,"flag_rd":false,"flag_ra":false,"flag_z":false,"flag_ad":false,"flag_cd":false,"rcode":"NOERROR","questions":[],"answers":[{"name":"Google-Home-Mini-3c8bbcf90b85bf733ab898b6c08a21c5._googlecast._tcp.local","type":"TXT","ttl":4500,"class":"IN","flush":true,"data":[{"type":"Buffer","data":[105,100,61,51,99,56,98,98,99,102,57,48,98,56,53,98,102,55,51,51,97,98,56,57,56,98,54,99,48,56,97,50,49,99,53]},{"type":"Buffer","data":[99,100,61,54,55,48,66,67,48,70,69,56,52,69,67,49,55,57,70,56,51,51,57,50,54,65,69,69,56,70,70,67,55,66,66]},{"type":"Buffer","data":[114,109,61]},{"type":"Buffer","data":[118,101,61,48,53]},{"type":"Buffer","data":[109,100,61,71,111,111,103,108,101,32,72,111,109,101,32,77,105,110,105]},{"type":"Buffer","data":[105,99,61,47,115,101,116,117,112,47,105,99,111,110,46,112,110,103]},{"type":"Buffer","data":[102,110,61,79,102,105,115]},{"type":"Buffer","data":[99,97,61,49,57,57,49,55,50]},{"type":"Buffer","data":[115,116,61,48]},{"type":"Buffer","data":[98,115,61,70,65,56,70,67,65,53,69,67,66,55,67]},{"type":"Buffer","data":[110,102,61,49]},{"type":"Buffer","data":[114,115,61]}]}],"authorities":[],"additionals":[]}
    //Google-Home-Mini-3c8bbcf90b85bf733ab898b6c08a21c5._googlecast._tcp.local
  const regexp = /Google-Home-Mini[\s*A_Za-z0-9\_\.\-]*/gi
  const matches = devnameData.match(regexp)

  return Array.from(matches)[0]

}catch(e){return ' '
}

}

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



//**********************************************  HONEYWELL  ********************************************************* */

//validate the DeviceName
function validateDeviceNameHoneywell(devnameData) {
  try{
  const regexp = /honeywell[\s*\d*\.A_Za-z0-9\(\)\_]*/gi
  const matches = devnameData.match(regexp)

  return Array.from(matches)[0]

}catch(e){return ' '
}

}



//**********************************************  DAIKIN  ********************************************************* */

//validate the DeviceName
function validateDeviceNameDaikin(devnameData) {
  try{
    const regexp = /daikin[\s*\d*\.A_Za-z0-9\(\)\_]*/gi
  const matches = devnameData.match(regexp)

  return Array.from(matches)[0]

}catch(e){return ' '
}

}



//**********************************************  SENSIBO  ********************************************************* */

//validate the DeviceName
function validateDeviceNameSensibo(devnameData) {
  try{
    const regexp = /sensibo[\s*\d*\.A_Za-z0-9\(\)\_]*/gi
  const matches = devnameData.match(regexp)

  return Array.from(matches)[0]

}catch(e){return ' '
}

}




//**********************************************  ECOBEE  ********************************************************* */

//validate the DeviceName
function validateDeviceNameEcobee(devnameData) {
  try{
    const regexp = /ecobee[\s*\d*\.A_Za-z0-9\(\)\_]*/gi
  const matches = devnameData.match(regexp)

  return Array.from(matches)[0]

}catch(e){return ' '
}

}




//**********************************************  NEST  ********************************************************* */

//validate the DeviceName
function validateDeviceNameGoogle(devnameData) {
  try{
  const regexp = /nest[\s*\d*\.A_Za-z0-9\(\)\_]*/gi
  const matches = devnameData.match(regexp)

  return Array.from(matches)[0]

}catch(e){return ' '
}

}




//**********************************************  dsc  ********************************************************* */

//validate the DeviceName
function validateDeviceNameDCS(devnameData) {
  try{
  const regexp = /dsc[\s*\d*\.A_Za-z0-9\(\)\_]*/gi
  const matches = devnameData.match(regexp)

  return Array.from(matches)[0]

}catch(e){return ' '
}

}

//^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$
//validate the MacAddress
function validateMacAddress(macData) {
  
  try{
    const regexp = '([0-9a-fA-F]{2}[:.-]?){5}[0-9a-fA-F]{2}';
    const matches = macData.matchAll(regexp);
    return Array.from(matches)[0][0];
    }catch(e){return ' '
  }
}

//validate the IPV6address
function validateIPv6(ipv6data) {
  try{
    const regexp = '(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))';
    const matches = ipv6data.matchAll(regexp);
    return Array.from(matches)[0][0];
    }catch(e){return ' '
  }

}

//validate the commentizeLogs
function validateCommentizeLogs(devnameData) {
  try{
    const highlightNames = "********************************************"
  return highlightNames + devnameData + '  Device Found' + highlightNames

}
catch(e){return devnameData}

}


module.exports={
    isString,
    formatDate,
    validateIPv4,
    validateIPv6,
    validateMacAddress,
    validateDeviceNameShelly,
    validateDeviceNameSonos,
    validateDeviceNameSonoff,
    validateDeviceNameWemo,
    validateDeviceNameSmartThing,
    validateDeviceNamePhilipsHue,
    validateDeviceNameNetatmo,
    validateDeviceNameHorus,
    validateDeviceNameHikVision,
    validateDeviceNameGoogleMini,
    validateDeviceNameEzlo, 
    validateDeviceNameHoneywell,
    validateDeviceNameDaikin,
    validateDeviceNameEcobee,
    validateDeviceNameSensibo,
    validateDeviceNameGoogle,
    validateDeviceNameDCS,
    validateCommentizeLogs
};
