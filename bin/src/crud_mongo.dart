part of ompa;

class CrudMongo extends Crud{
  DbCollection _db;
  CrudMongo(this._db);
  
  String newId() => new ObjectId().toHexString();
  
  Future create(Map json) => _db.insert(_toDb(json));
  Future<List<Map>> readAll() => _db.find().stream.map(_fromDb).toList();
  Future<Map> read(String id) 
    => _db.findOne({'_id': new ObjectId.fromHexString(id)}).then(_fromDb);
  Future update(Map json){
    var data = _toDb(json);
    return _db.update({'_id': data['_id']}, data);
  }
  Future delete(Map json)
    => _db.remove({'_id':  new ObjectId.fromHexString(json['id'])});
  
  Map _toDb(Map data){
    var mongo = new Map.from(data);
    String id = mongo.remove('id');
    if(id == null || id.isEmpty){
      mongo['_id'] = new ObjectId();
    }else{
      mongo['_id'] = new ObjectId.fromHexString(id);
    }
    return mongo;
  }

  Map _fromDb(Map mongo){
    var data = new Map.from(mongo);
    data['id'] = data.remove('_id').toHexString();
    return data;
  }
}