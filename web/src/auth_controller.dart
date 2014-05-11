part of ompa_html;

@Controller( selector: '[ompa-auth]', publishAs: 'OmpaAuth')
@Injectable()
class AuthController{
  bool loggedIn = false;
  String key;
  
  AuthService _service;
  
  AuthController(AuthService this._service) {
    loggedIn = _service.auth != null;
    _service.onChange.listen((Auth key)=>loggedIn = key != null);
  }
  
  login() => _service.login(key);
  
  logout() => _service.logout();
}