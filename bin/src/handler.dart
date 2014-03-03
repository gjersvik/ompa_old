part of ompa;

abstract class Handler{
  String name;
  
  Future<HttpRequest> handleRequest(HttpRequest req, Object json);
}