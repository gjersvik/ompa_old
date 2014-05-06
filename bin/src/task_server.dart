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
    var task = new Task(json);
    return new Future((){
      if(req.uri.pathSegments.length == 2
          && req.uri.pathSegments[1] == 'complete'){
        return _service.complete(task);
      }else{
        return _service.save(task);
      }
    }).then((Task task){
      print(task.json);
      return req.response
        ..statusCode = 200
        ..write(JSON.encode(task));
      
    });
  }
      
  Future<HttpRequest> delete(HttpRequest request, Map json) {
    return _service.remove(new Task(json))
        .then((task) => request.response
          ..statusCode = 200
          ..write(JSON.encode(task)));
  }
}