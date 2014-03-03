part of ompa;

class SuccessServer extends Handler{
  String name = 'success';
  
  final DbCollection _db;
  SuccessServer(this._db);
  
  Future save(Success success) => _db.insert(success.toDb()).then((_){
    return success;
  });
  
  Future<List<Success>> getDay(DateTime day){
    var start = new DateTime.utc(day.year,day.month,day.day);
    var end = new DateTime.utc(day.year,day.month,day.day + 1);
    return _db.find(where.inRange('time', start, end)).toList()
        .then((list) => list.map((s)=> new Success.fromDb(s)).toList());
  }
  
  Future<HttpRequest> handleRequest(HttpRequest req, Map json) {
    if(req.method == 'GET'){
      return get(req);
    }
    if(req.method == 'PUT'){
      return put(req, json);
    }
    req.response.statusCode = 404;
    return new Future.value(req);
  }
  
  Future<HttpRequest> get(HttpRequest req) {
    var path = req.uri.pathSegments;
    print(path);
    var day = new DateTime.utc(int.parse(path[1]),
        int.parse(path[2]),
        int.parse(path[3]));
    print(day);
    return getDay(day).then((List<Success> list){
      req.response..statusCode = 200
          ..write(JSON.encode(list));
    });
  }
  
  Future<HttpRequest> put(HttpRequest req, Map json) {
    return save(new Success.fromJson(json)).then((Success success){
      req.response..statusCode = 200
          ..write(success.toString());
    });
  }
}