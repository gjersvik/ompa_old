part of ompa_html;

class SuccessController{
  final Server _server;
  final Panels _panels;
  
  SuccessController(this._server, this._panels){
    _panels.add(new SuccessPanel());
  }
  
}