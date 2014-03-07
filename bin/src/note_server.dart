part of ompa;

class NoteServer extends Handler{
  String name = 'note';
  
  final NoteService _service;
  NoteServer(this._service);

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
    return _service.getAll().then((notes){
          req.response..statusCode = 200
              ..write(JSON.encode(notes));
        });
  }
  
  Future<HttpRequest> put(HttpRequest req, Map json) {
    return _service.save(new Note.fromJson(json))
        .then((_) => req.response.statusCode = 201);
  }
      
  Future<HttpRequest> delete(HttpRequest request, Map json) {
    return _service.remove(new Note.fromJson(json))
        .then((_) => request.response.statusCode = 204);
  }
}