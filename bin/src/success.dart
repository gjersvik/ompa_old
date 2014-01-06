part of ompa;

class Success{
  
  final RestfulServer _rest;
  final DbCollection _db;
  final Auth _auth;
  Success(this._rest, this._db, this._auth){
    _rest.onPut('success/add', _auth.handlerBody((HttpRequest request, params, body) {
      return add(JSON.decode(body)).then((data){
        request.response..statusCode = 200
            ..write(data['text']);
      });
    }));
  }
  
  Future add([Map success]){
    if(success == null){
      success = {};
    }
    var data = {};
    if(success.containsKey('desc')){
      data['desc'] = success['desc'];
    }
    if(success.containsKey('time')){
      data['_id'] = DateTime.parse(success['time']).toUtc();
    }else{
      data['_id'] = new DateTime.now().toUtc();
    }
    return _db.insert(data);
  }
}