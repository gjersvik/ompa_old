part of ompa;

class Note{
  
  final RestfulServer _rest;
  final DbCollection _db;
  Note(this._rest, this._db){
    _rest.onGet('note/{name}', (request, Map<String,String> params) {
      var id = params['name'].replaceAll('_',' ');
      return _db.findOne({'_id': id})
          .then((data){
            request.response..statusCode = 200
                ..write(data['text']);
          }).catchError((e){
            request.response..statusCode = 500
                ..write(e);
          });
    });

    _rest.onPut('note/{name}', (HttpRequest request, params, body) {
      var id = params['name'].replaceAll('_',' ');
      return _db.update({'_id': id}, {'_id': id, 'text': body}, upsert: true)
          .then((_){
            request.response.statusCode = 201;
          }).catchError((e){
            request.response..statusCode = 500
                ..write(e);
          });
    });
    
    _rest.onDelete('note/{name}', (HttpRequest request, params) {
      var id = params['name'].replaceAll('_',' ');
      return _db.remove({'_id': id})
          .then((_){
            request.response.statusCode = 204;
          }).catchError((e){
            request.response..statusCode = 500
                ..write(e);
          });
    });
    
    _rest.onGet('note', (HttpRequest request, params){
      return _db.find().stream.map((Map m){
          return JSON.encode({
            'name': m['_id'],
            'text': m['text'],
          });
        }).join(',').then((data){
          request.response..statusCode = 200
              ..write('[$data]');
        }).catchError((e){
          request.response..statusCode = 500
              ..write(e);
        });
    });
  }
}