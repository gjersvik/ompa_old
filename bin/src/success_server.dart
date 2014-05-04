part of ompa;

class SuccessServer extends Handler{
  String name = 'success';
  
  SuccessService _service;
  SuccessServer(this._service);
  
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
    return _service.getDay(day).then((List<Success> list){
      req.response..statusCode = 200
          ..write(JSON.encode(list));
    });
  }
  
  Future<HttpRequest> put(HttpRequest req, Map json) {
    return _service.save(new Success(json)).then((Success success){
      req.response..statusCode = 200
          ..write(success.toString());
    });
  }
}