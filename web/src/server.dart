part of ompa_html;

class Server{
  final String server;
  
  final Auth _auth;
  Server(this.server, this._auth){
  }
  
  Future<String> get(String path) => _send(path, 'GET');
  Future<Object> getJson(String path) => get(path).then(JSON.decode);
  Future<String> put(String path, String body) => _send(path, 'PUT', body);
  Future<Object> putJson(String path, data) => 
      put(path, JSON.encode(data)).then(JSON.decode);
  Future<String> delete(String path) => _send(path, 'DELETE');
  
  Future<String> _send(String path, String method, [String body]){
    path = path.replaceAll(' ', '_');
    return HttpRequest.request('$server$path', 
        method: method,
        withCredentials: true,
        requestHeaders: {
          'Authorization': _auth.sign(path: '/$path', body: body , method: method)
        },
        sendData: body)
        .then((http) => http.response.toString());
  }
}