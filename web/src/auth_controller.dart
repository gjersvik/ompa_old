part of ompa_html;

@NgController( selector: '[ompa-auth]', publishAs: 'OmpaAuth')
class AuthController{
  bool loggedIn = false;
  String key;
  
  AuthService _service;
  
  AuthController(AuthService this._service) {
    _service.onChange.listen((Auth key)=>loggedIn = key != null);
  }
  
  login() => _service.login(key);
  
  logout() => _service.logout();
}