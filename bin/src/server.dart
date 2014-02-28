part of ompa;

class Server{
  Auth _auth;
  
  Map _config;
  Map<String,Handler> _handlers = {};
  Server(this._auth);
  
  addHandler(Handler hand){
    _handlers[hand.name] = hand;
  }
  
  start(Map config){
    HttpServer.bindSecure("0.0.0.0", 8080).then((HttpServer server){
      server.listen((HttpRequest req){
        return getBody(req)
            .then((String body) => request(req,body))
            .catchError((e){
              req.response
                  ..statusCode = 500
                  ..write(e);
              print(e);
            }).whenComplete(() => req.response.close());
      });
    });
  }
  
  Future<String> getBody(HttpRequest req){
    if(req.contentLength == 0){
      return new Future.value('');
    }
    return UTF8.decodeStream(req);
  }
  
  request(HttpRequest req, String body){
    addHeaders(req);
    if(auth(req, body) == false){
      return;
    }
  }
  
  addHeaders(HttpRequest req){
    req.response.headers
        ..contentType = new ContentType('application', 'json', charset: 'utf-8')
        ..add('Access-Control-Allow-Origin',_config['origin'])
        ..add('Access-Control-Allow-Methods', 'GET,PUT,DELETE')
        ..add('Access-Control-Allow-Credentials', 'true')
        ..add('Access-Control-Allow-Headers', 'Authorization');
  }
  
  bool auth(HttpRequest req, String body){
    if(req.headers['Authorization'] != null){
      var valid = _auth.validate(req.headers['Authorization'].first,
          path: req.uri.path,
          method: req.method,
          body: body);
    }
    req.response.statusCode = 403;
    return false;
  }
  
  
  onOptions(request) {
    request.response.statusCode = 204;
  }
  
}