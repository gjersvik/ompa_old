part of ompa;

class Server{
  Auth _auth;
  
  Map _config;
  Map<String,Handler> _handlers = {};
  
  addHandler(Handler hand){
    _handlers[hand.name] = hand;
  }
  
  setAuth(Auth auth) => _auth = auth;
  
  Future start(Map config){
    _config = config;
    return HttpServer.bind("0.0.0.0", 8080).then((HttpServer server){
      server.listen((HttpRequest req){
        return getBody(req)
            .then((String body) => request(req,body))
            .catchError((e,stack){
              req.response
                  ..statusCode = 500
                  ..write(e)
                  ..write(stack);
              print(e);
              print(stack);
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
    if(req.method == "OPTIONS"){
      req.response.statusCode = 204;
      return null;
    }
    
    if(auth(req, body) == false){
      return null;
    }
    
    var name = req.uri.pathSegments.first;
    if(_handlers.containsKey(name)){
      return _handlers[name].handleRequest(req, decodeBody(body));
    }else{
      req.response.statusCode = 404;
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
      return _auth.validate(req.headers['Authorization'].first,
          path: req.uri.path,
          method: req.method,
          body: body);
    }
    req.response.statusCode = 403;
    return false;
  }
  
  Object decodeBody(String body){
    if(body == null || body == ''){
      return null;
    }
    return JSON.decode(body);
  }
}