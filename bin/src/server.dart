part of ompa;

class Server{
  Map _config;
  Map<String,Handler> _handlers = {};
  
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
                  ..write(e)
                  ..close();
              print(e);
            });
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
  }
  
  addHeaders(HttpRequest req){
    req.response.headers
        ..contentType = new ContentType('application', 'json', charset: 'utf-8')
        ..add('Access-Control-Allow-Origin',_config['origin'])
        ..add('Access-Control-Allow-Methods', 'GET,PUT,DELETE')
        ..add('Access-Control-Allow-Credentials', 'true')
        ..add('Access-Control-Allow-Headers', 'Authorization');
  }
  
  
  onOptions(request) {
    request.response.statusCode = 204;
  }
  
}