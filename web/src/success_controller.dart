part of ompa_html;

class SuccessController{
  static const DAY = const Duration(days:1);
  final Server _server;
  final Panels _panels;
  
  DateTime date = new DateTime.now().toUtc();
  SuccessPanel _success = new SuccessPanel();
  SuccessController(this._server, this._panels){
    _panels.add(_success);
    _success.onAdd.listen(add);
    _success.onNext.listen(next);
    _success.onPrev.listen(prev);
    getDay(date);
  }
  
  add(String desc){
    var success = new Success();
    success.desc = desc;
    _server.putJson('success/add',success).then((_) => getDay(date));
  }
  
  next([ _ ]){
    date = date.add(DAY);
    getDay(date);
  }
  
  prev([ _ ]){
    date = date.subtract(DAY);
    getDay(date);
  }
  
  getDay(DateTime day){
    return _server.getJson('success/${day.year}/${day.month}/${day.day}')
        .then((List data) => data.map((d)=> new Success.formJson(d)).toList())
        .then((data) => _success.setData(date, data));
  }
}