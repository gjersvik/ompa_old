part of ompa;

class SuccessServer{
  
  final RestfulServer _rest;
  final DbCollection _db;
  final Auth _auth;
  SuccessServer(this._rest, this._db, this._auth){
    _rest.onPut('success/add', _auth.handlerBody((HttpRequest request, params, body) {
      return save(new Success.formJson(body)).then((Success success){
        request.response..statusCode = 200
            ..write(success.toString());
      });
    }));
  }
  
  Future save(Success success) => _db.insert(success.toDB()).then((_){
    return success;
  });
}