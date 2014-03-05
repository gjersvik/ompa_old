part of ompa_html;

@NgController( selector: '[ompa]', publishAs: 'Ompa')
class OmpaController{
  OmpaController(AuthService _auth, Injector _in){
    Panels panels = new Panels();
    document.body.append(panels.elem);
    _auth.onChange.first.then((auth){
      var note = new NoteController(_in.get(Server), panels);
    });
  }
}