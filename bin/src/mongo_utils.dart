part of ompa;

Map toMongo(Map data){
  var mongo = new Map.from(data);
  String id = mongo.remove('id');
  if(id == null || id.isEmpty){
    mongo['_id'] = new ObjectId();
  }else{
    mongo['_id'] = new ObjectId.fromHexString(id);
  }
  return mongo;
}

Map fromMongo(Map mongo){
  var data = new Map.from(mongo);
  data['id'] = data.remove('_id').toHexString();
  return data;
}