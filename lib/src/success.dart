part of ompa_common;

class Success extends Model{
  String desc = '';
  DateTime time = new DateTime.now();
  Map<String,String> meta = {};
  ObjectId _id = new ObjectId();
  
  Success();

  factory Success.formJson(json){
    if(json is String){
      json = JSON.decode(json);
    }
    var success = new Success();
    success.time = DateTime.parse(json['time']);
    success.desc = json['desc'];
    success.meta = json['meta'];
    return success;
  }
  
  factory Success.formDb(Map data){
    var success = new Success();
    success._id = data['_id'];
    success.time = data['time'];
    success.desc = data['desc'];
    success.meta = data['meta'];
    return success;
  }
  
  Map toJson(){
    return {
      'time': time.toUtc().toString(),
      'desc': desc,
      'meta': meta
    };
  }
  
  String toString(){
    return JSON.encode(this);
  }
  
  Map toDb(){
    return {
      '_id': _id,
      'time': time.toUtc(),
      'desc': desc,
      'meta': meta
    };
  }
}