part of ompa_html;

@NgController( selector: '[ompa]', publishAs: 'Ompa')
class OmpaController{
  OmpaController(AuthController _authctrl){
    Panels panels = new Panels();
    document.body.append(panels.elem);
    _authctrl.onAuth.then((auth){
      var server;
      if(window.location.host == '127.0.0.1:3030'){
        server = new Server('http://127.0.0.1:8080/',auth);
      }else{
        server = new Server('http://api.ompa.olem.org:8080/',auth);
      }
      var success = new SuccessController(server,panels);
      var note = new NoteController(server, panels);
      var tasks = new Tasks(document.body);
    });
  }
}