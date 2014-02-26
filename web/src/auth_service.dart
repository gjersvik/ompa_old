part of ompa_html;

class AuthService{
  Auth auth = null;
  Stream<Auth> onChange;
  
  StreamController<Auth> _onChange = new StreamController<Auth>.broadcast();
  
  AuthService() {
    onChange = _onChange.stream;
    
    if(window.sessionStorage.containsKey('passhash')){
      _setKey(new Auth.fromBase64(window.sessionStorage['passhash']));
    }
  }
  
  login(String key) => _setKey(new Auth.fromPassword(key));
  
  logout() => _setKey(null);
  
  _setKey(Auth key){
    auth = key;
    _onChange.add(key);
    if(key != null){
      window.sessionStorage['passhash'] = auth.toBase64();
    }else{
      window.sessionStorage.remove('passhash');
    }
  }
}