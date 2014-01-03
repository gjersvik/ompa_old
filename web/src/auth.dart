part of ompa_html;

Future<List<int>> auth(Panels panels){
  if(window.sessionStorage.containsKey('passhash')){
    var passhash = window.sessionStorage['passhash'];
    passhash = CryptoUtils.base64StringToBytes(passhash);
    return new Future.value(passhash);
  }
  
  var salt = '5Yc8GDdmKxlYpLnzcGBKpxZ0YU1rottDYGsWbDJrTK4WBsp2Hzd1sOSjAOLPdBfc';
  var authpanel = new AuthPanel();
  panels.add(authpanel);
  
  return authpanel.onPassword.first.then((pass){
    var key = pass + salt;
    var hash = new SHA256();
    hash.add(key.codeUnits);
    panels.remove(authpanel);
    
    var passhash = hash.close();
    window.sessionStorage['passhash'] = CryptoUtils.bytesToBase64(passhash);
    return passhash;
  });
}