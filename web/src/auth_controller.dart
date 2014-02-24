part of ompa_html;

@NgController( selector: '[ompa-auth]', publishAs: 'OmpaAuth')
class AuthController{
  bool loggedIn = false;
  String key;
}