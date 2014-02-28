part of ompa;

abstract class Server{
  String name;
  
  Future<HttpRequest> handleRequest(HttpRequest req, Map json);
}