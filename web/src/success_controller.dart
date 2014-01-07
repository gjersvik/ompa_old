part of ompa_html;

class SuccessController{
  final Server _server;
  final Panels _panels;
  
  SuccessController(this._server, this._panels){
    _panels.add(new SuccessPanel());
  }
  
  
  add(String desc){
    _server.putJson('success/add',{'desc':desc});
  }
}