part of ompa_common;

class Crud{
  Map _data = {};
  int _lastid = 0;
  
  String newId(){
    _lastid += 1;
    return _lastid.toString();
  }
  
  Future create(Map json){
    _data[json['id']] = new Map.from(json);
    return new Future.value(null);
  }
  
  Future<List<Map>> readAll(){
    return new Future(() => _data.values.map((d)=> new Map.from(d)).toList());
  }
  
  Future<Map> read(String id) => new Future(() => new Map.from(_data[id]));
  
  Future update(Map json){
    _data[json['id']] = new Map.from(json);
    return new Future.value(null);
  }
  
  Future delete(Map json){
    _data.remove(json['id']);
    return new Future.value(null);
  }
}