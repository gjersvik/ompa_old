part of ompa_html;

@NgController( selector: '[ompa-auth]', publishAs: 'OmpaAuth')
class AuthController{
  bool loggedIn = false;
  String key;
  
  Future<Auth> onAuth;
  
  // HACK
  static Completer<Auth> _onAuth =  new Completer<Auth>();
  
  
  AuthController() {
    onAuth = _onAuth.future;
    // HACK
    if(_onAuth.isCompleted){
      return;
    }
      
    if(window.sessionStorage.containsKey('passhash')){
      _onAuth.complete(new Auth.fromBase64(window.sessionStorage['passhash']));
      loggedIn = true;
    }
  }
  
  login(){
    var auth = new Auth.fromPassword(key);
    _onAuth.complete(auth);
    window.sessionStorage['passhash'] = auth.toBase64();
    loggedIn = true;
  }
  
  logout(){
    loggedIn = false;
    window.sessionStorage.remove('passhash');
    window.location.assign(window.location.href);
  }
}