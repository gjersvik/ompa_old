part of ompa;

class SuccessServer{
  
  final RestfulServer _rest;
  final DbCollection _db;
  final ServerAuth _auth;
  SuccessServer(this._rest, this._db, this._auth){
    _rest.onPut('success/add', _auth.handlerBody((HttpRequest request, params, body) {
      return save(new Success.formJson(body)).then((Success success){
        request.response..statusCode = 200
            ..write(success.toString());
      });
    }));
    

    _rest.onGet('success/{year}/{month}/{day}', _auth.handler((HttpRequest request, params) {
      var day = new DateTime.utc(int.parse(params['year']),
          int.parse(params['month']),
          int.parse(params['day']));
      return getDay(day)
        .then((List<Success> list){
        request.response..statusCode = 200
            ..write(JSON.encode(list));
      });
    }));
  }
  
  Future save(Success success) => _db.insert(success.toDb()).then((_){
    return success;
  });
  
  Future<List<Success>> getDay(DateTime day){
    var start = new DateTime.utc(day.year,day.month,day.day);
    var end = new DateTime.utc(day.year,day.month,day.day + 1);
    return _db.find(where.inRange('time', start, end)).toList()
        .then((list) => list.map((s)=> new Success.formDb(s)).toList());
  }
}