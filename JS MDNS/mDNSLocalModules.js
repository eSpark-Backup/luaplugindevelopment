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
  validateCommentizeLogs
};