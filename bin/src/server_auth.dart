part of ompa;

class ServerAuth{
  Auth _auth;
  ServerAuth(String key){
    _auth = new Auth.fromBase64(key);
  }
  
  Function handler( Future handler(HttpRequest, Map)){
    return (HttpRequest request, Map params){
      if(auth(request) == false){
        return request.response..statusCode = 403;
      }
      return handler(request,params).catchError((e){
        request.response..statusCode = 500
            ..write(e);
        print(e);
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
        print(e);
      });
    };
  }
  
  auth(HttpRequest req, [body]){
    return _auth.validate(req.headers['Authorization'].first,
        path: req.uri.path,
        metode: req.method,
        body: body);
  }
}