part of ompa;

class Note{
  
  final RestfulServer _rest;
  final DbCollection _db;
  final List<int> _key;
  Note(this._rest, this._db, this._key){
    _rest.onGet('note/{name}', handler((request, params) {
      var id = params['name'].replaceAll('_',' ');
      return _db.findOne({'_id': id}).then((data){
        request.response..statusCode = 200
            ..write(data['text']);
      });
    }));

    _rest.onPut('note/{name}', handlerBody((HttpRequest request, params, body) {
      var id = params['name'].replaceAll('_',' ');
      return _db.update({'_id': id}, {'_id': id, 'text': body}, upsert: true)
          .then((_){
            request.response.statusCode = 201;
          });
    }));
    
    _rest.onDelete('note/{name}', handler((HttpRequest request, params) {
      var id = params['name'].replaceAll('_',' ');
      return _db.remove({'_id': id})
          .then((_){
            request.response.statusCode = 204;
          });
    }));
    
    _rest.onGet('note', handler((HttpRequest request, params){
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
  
  Function handler( Future handler(HttpRequest, Map)){
    return (HttpRequest request, Map params){
      if(auth(request) == false){
        return request.response..statusCode = 403;
      }
      return handler(request,params).catchError((e){
        request.response..statusCode = 500
            ..write(e);
      });
    };
  }
  
  Function handlerBody( Future handler(HttpRequest, Map, body)){
    return (HttpRequest request, Map params, body){
      if(auth(request, body) == false){
        return request.response..statusCode = 403;
      }
      return handler(request,params,body).catchError((e){
        request.response..statusCode = 500
            ..write(e);
      });
    };
  }
  
  auth(HttpRequest req, [body]){
    var hmac = new HMAC(new SHA256(),_key);
    hmac.add(req.uri.path.codeUnits);
    hmac.add(req.method.codeUnits);
    if(body != null){
      hmac.add(body.codeUnits);
    }
    var digest = CryptoUtils.base64StringToBytes(
        req.headers['Authorization'].first.split('"')[1]);
    return hmac.verify(digest);
  }
}