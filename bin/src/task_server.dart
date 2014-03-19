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
              ..write(JSON.encode(tasks, toEncodable:(t) => t.toMap()));
        });
  }
  
  Future<HttpRequest> put(HttpRequest req, Map json) {
    if(req.uri.pathSegments.length == 2 
        && req.uri.pathSegments[1] == 'complete'){
      return _service.complete(new Task.fromMap(json))
          .then((task) => req.response..statusCode = 200
            ..write(JSON.encode(task.toMap())));
    }
    return _service.save(new Task.fromMap(json))
        .then((task) => req.response..statusCode = 200
          ..write(JSON.encode(task.toMap())));
  }
      
  Future<HttpRequest> delete(HttpRequest request, Map json) {
    return _service.remove(new Task.fromMap(json))
        .then((task) => request.response..statusCode = 200
        ..write(JSON.encode(task.toMap())));
  }
}