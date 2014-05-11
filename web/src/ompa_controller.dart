part of ompa_html;

@Controller( selector: '[ompa]', publishAs: 'Ompa')
@Injectable()
class OmpaController{
  OmpaController(AuthService _auth, Injector _in){
  }
}