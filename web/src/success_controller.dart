part of ompa_html;

class SuccessController{
  final Server _server;
  final Panels _panels;
  
  SuccessPanel _success = new SuccessPanel();
  SuccessController(this._server, this._panels){
    _panels.add(_success);
    _success.onAdd.listen(add);
  }
  
  
  add(String desc){
    var success = new Success();
    success.desc = desc;
    _server.putJson('success/add',success);
  }
}