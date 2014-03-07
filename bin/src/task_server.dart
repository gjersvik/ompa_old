part of ompa;

class TaskServer extends Handler{
  String name = 'task';
  
  final TaskService _service;
  TaskServer(this._service);

  Future<HttpRequest> handleRequest(HttpRequest req, Map json) {
    if(req.method == 'GET'){
      return get(req);
    }
    if(req.method == 'PUT'){
      return put(req, json);
    }
    if(req.method == 'DELETE'){
      return delete(req, json);
    }
    req.response..statusCode = 404;
    return new Future.value(req);
  }
  
  Future<HttpRequest> get(HttpRequest req) {
    return _service.getAll().then((tasks){
          req.response..statusCode = 200
              ..write(JSON.encode(tasks));
        });
  }
  
  Future<HttpRequest> put(HttpRequest req, Map json) {
    if(req.uri.pathSegments[1] == 'complete'){
      return _service.complete(new Task.fromJson(json))
          .then((_) => req.response.statusCode = 204);
    }
    return _service.save(new Task.fromJson(json))
        .then((_) => req.response.statusCode = 201);
  }
      
  Future<HttpRequest> delete(HttpRequest request, Map json) {
    return _service.remove(new Task.fromJson(json))
        .then((_) => request.response.statusCode = 204);
  }
}