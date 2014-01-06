part of ompa;

class Auth{
  List<int> _key;
  Auth(String key){
    _key = CryptoUtils.base64StringToBytes(key);
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
