part of ompa_common;

class Task extends Model{
  String name = '';
  ObjectId id = new ObjectId();
  
  Task();

  factory Task.fromJson(json){
    if(json is String){
      json = JSON.decode(json);
    }
    var task = new Task();
    task.name = json['name'];
    task.id = new ObjectId.fromHexString(json['id']);
    return task;
  }
  
  factory Task.fromDb(Map data){
    var task = new Task();
    task.name = data['name'];
    task.id = data['_id'];
    return task;
  }
  
  Map toJson(){
    return {
      'id': id.toHexString(),
      'name': name
    };
  }
  
  Map toDb(){
    return {
      '_id': id,
      'name': name
    };
  }
}