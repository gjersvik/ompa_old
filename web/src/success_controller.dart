part of ompa_html;

class SuccessController{
  final Server _server;
  final Panels _panels;
  
  SuccessPanel _success = new SuccessPanel();
  SuccessController(this._server, this._panels){
    _panels.add(_success);
    _success.onAdd.listen(add);
    var day = new DateTime.now().toUtc();
    getDay(day).then((data){
      _success.setData(day, data);
    });
  }
  
  
  add(String desc){
    var success = new Success();
    success.desc = desc;
    _server.putJson('success/add',success);
  }
  
  Future<List<Success>> getDay(DateTime day){
    return _server.getJson('success/${day.year}/${day.month}/${day.day}')
        .then((List data) => data.map((d)=> new Success.formJson(d)));
  }
}