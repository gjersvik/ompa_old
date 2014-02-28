part of ompa;

class Rest{
  
  final Map _config;
  Rest(this._config){
    ready = RestfulServer.bind(host: "0.0.0.0").then(start);
  }
  
  RestfulServer server;
  Future<RestfulServer> ready;
  
  core( HttpRequest req){
    req.response.headers
      ..add('Access-Control-Allow-Origin',_config['origin'])
      ..add('Access-Control-Allow-Methods', 'GET,PUT,DELETE')
      ..add('Access-Control-Allow-Credentials', 'true')
      ..add('Access-Control-Allow-Headers', 'Authorization');
  }
  
  start( RestfulServer _rest){
    server = _rest;
    var old = server.preProcessor;
    server.preProcessor = (HttpRequest res){
      core( res );
      res.response.headers.contentType = new ContentType('application', 'json', charset: 'utf-8');
      return old( res );
    };
    
    server.onOptions('', (request, params) {
      request.response.statusCode = 204;
    });
  }
}