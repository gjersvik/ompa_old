part of ompa;

class Note{
  
  final RestfulServer _rest;
  final DbCollection _db;
  final List<int> _key;
  Note(this._rest, this._db, this._key){
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
      auth(request);
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
  
  auth(HttpRequest req, [body]){
    var hmac = new HMAC(new SHA256(),_key);
    print(req.uri.path);
    print(req.method);
    hmac.add(req.uri.path.codeUnits);
    hmac.add(req.method.codeUnits);
    if(body != null){
      hmac.add(body.codeUnits);
    }
    var digest = CryptoUtils.base64StringToBytes(
        req.headers['Authorization'].first.split('"')[1]);
    print(hmac.verify(digest));
  }
}