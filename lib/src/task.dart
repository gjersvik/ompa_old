part of ompa_common;

class Task extends Model{
  String name = '';
  ObjectId _id;
  
  Task();

  factory Task.fromJson(json){
    if(json is String){
      json = JSON.decode(json);
    }
    var task = new Task();
    task.name = json['name'];
    if(json['_id'] != null){
      task._id = ObjectId.parse(json['_id']);
    }
    return task;
  }
  
  factory Task.fromDb(Map doc){
    var task = new Task();
    task.name = doc['name'];
    task._id = doc['_id'];
    return task;
  }
  
  Map toJson(){
    var json = {'name' : name};
    if(_id != null){
      json['_id'] = _id.toHexString();
    }
    return json;
  }
  
  Map toDb(){
    var doc = {'name' : name};
    if(_id != null){
      doc['_id'] = _id;
    }
    return doc;
  }
}