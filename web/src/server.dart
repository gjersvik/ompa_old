part of ompa_html;

class Server{
  final String server;
  
  Server(this.server){
    
  }
  
  Future<String> get(String path){
    path = path.replaceAll(' ', '_');
    return HttpRequest.getString('$server$path');
  }
  
  Future put(String path, String body){
    path = path.replaceAll(' ', '_');
    return HttpRequest.request('$server$path', 
        method: 'PUT', 
        sendData: body);
  }
}