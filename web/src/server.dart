part of ompa_html;

class Server{
  final String server;
  
  final List<int> _key;
  Server(this.server, this._key){
  }
  
  Future<String> get(String path) => _send(path, 'GET');
  Future<Object> getJson(String path) => get(path).then(JSON.decode);
  Future<String> put(String path, String body) => _send(path, 'PUT', body);
  Future<String> delete(String path) => _send(path, 'DELETE');
  
  Future<String> _send(String path, String method, [String body]){
    path = path.replaceAll(' ', '_');
    var hmac = new HMAC(new SHA256(),_key);
    print('/$path');
    print(method);
    hmac.add('/$path'.codeUnits);
    hmac.add(method.codeUnits);
    if(body != null){
      hmac.add(body.codeUnits);
    }
    var key = CryptoUtils.bytesToBase64(hmac.close());
    return HttpRequest.request('$server$path', 
        method: method,
        withCredentials: true,
        requestHeaders: {
          'Authorization': 'OMPA-TOKEN hash="$key"'
        },
        sendData: body)
        .then((http) => http.response.toString());
  }
}