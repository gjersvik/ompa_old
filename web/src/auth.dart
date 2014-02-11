part of ompa_html;

Future<Auth> auth(Panels panels){
  if(window.sessionStorage.containsKey('passhash')){
    var auth = new Auth.fromBase64(window.sessionStorage['passhash']);
    return new Future.value(auth);
  }
  
  var authpanel = new AuthPanel();
  panels.add(authpanel);
  
  return authpanel.onPassword.first.then((pass){
    panels.remove(authpanel);
    
    var auth = new Auth.fromPassword(pass);
    window.sessionStorage['passhash'] = auth.toBase64();
    return auth;
  });
}