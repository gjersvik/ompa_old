part of ompa;

class Rest{
  
  
  Rest(Map config){
    ready = RestfulServer.bind().then(start);
  }
  
  RestfulServer server;
  Future<RestfulServer> ready;
  
  core( HttpRequest req){
    req.response.headers
      ..add('Access-Control-Allow-Origin','http://127.0.0.1:3030')
      ..add('Access-Control-Allow-Methods', 'GET,PUT,DELETE')
      ..add('Access-Control-Allow-Credentials', 'true')
      ..add('Access-Control-Allow-Headers', 'Authorization');
  }
  
  start( RestfulServer _rest){
    server = _rest;
    var old = server.preProcessor;
    server.preProcessor = (HttpRequest res){
      core( res );
      return old( res );
    };
    
    server.onOptions('', (request, params) {
      request.response.statusCode = 204;
    });
  }
}