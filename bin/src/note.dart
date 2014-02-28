part of ompa;

class OldNote{
  
  final RestfulServer _rest;
  final DbCollection _db;
  final ServerAuth _auth;
  OldNote(this._rest, this._db, this._auth){
    _rest.onGet('note/{name}', _auth.handler((request, params) {
      var id = params['name'].replaceAll('_',' ');
      return _db.findOne({'_id': id}).then((data){
        request.response..statusCode = 200
            ..write(data['text']);
      });
    }));

    _rest.onPut('note/{name}', _auth.handlerBody((HttpRequest request, params, body) {
      var id = params['name'].replaceAll('_',' ');
      return _db.update({'_id': id}, {'_id': id, 'text': body}, upsert: true)
          .then((_){
            request.response.statusCode = 201;
          });
    }));
    
    _rest.onDelete('note/{name}', _auth.handler((HttpRequest request, params) {
      var id = params['name'].replaceAll('_',' ');
      return _db.remove({'_id': id})
          .then((_){
            request.response.statusCode = 204;
          });
    }));
    
    _rest.onGet('note', _auth.handler((HttpRequest request, params){
      return _db.find().stream.map((Map m){
          return JSON.encode({
            'name': m['_id'],
            'text': m['text'],
          });
        }).join(',').then((data){
          request.response..statusCode = 200
              ..write('[$data]');
        });
    }));
  }
}