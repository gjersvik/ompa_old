part of ompa_html;

class Server{
  final String server;
  
  Server(this.server){
    
  }
  
  Future<Map> get(String path){
    path = path.replaceAll(' ', '_');
    return HttpRequest.getString('$server$path')
        .then(JSON.decode);
  }
  
  Future put(String path, Map data){
    path = path.replaceAll(' ', '_');
    return HttpRequest.request('$server$path', 
        method: 'PUT', 
        sendData: JSON.encode(data));
  }
}