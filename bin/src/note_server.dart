part of ompa;

class NoteServer{
  
  final RestfulServer _rest;
  final ServerAuth _auth;
  final NoteService _service;
  NoteServer(this._rest, this._auth, this._service){
    _rest.onGet('note/{name}', _auth.handler((request, params) {
      return _service.get(params['name'].replaceAll('_',' '))
          .then((note){
            request.response..statusCode = 200
                ..write(note.text);
          });
    }));

    _rest.onPut('note/{name}', _auth.handlerBody((HttpRequest request, params, body) {
      var note = new Note()
          ..name = params['name'].replaceAll('_',' ')
          ..text = body;
      return _service.save(note).then((_) => request.response.statusCode = 201);
    }));
    
    _rest.onDelete('note/{name}', _auth.handler((HttpRequest request, params) {
      return _service.get(params['name'].replaceAll('_',' '))
          .then(_service.remove)
          .then((_){
            request.response.statusCode = 204;
          });
    }));
    
    _rest.onGet('note', _auth.handler((HttpRequest request, params){
      return _service.getAll().toList()
        .then((notes){
          request.response..statusCode = 200
              ..write(JSON.encode(notes));
        });
    }));
  }
}