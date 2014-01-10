part of ompa_common;

class Success extends Model{
  String desc = '';
  DateTime time = new DateTime.now();
  
  Success();

  factory Success.formJson(String jsonstring){
    var json = JSON.decode(jsonstring);
    var success = new Success();
    success.time = DateTime.parse(json['time']);
    success.desc = json['desc'];
    return success;
  }
  
  Map toJson(){
    return {
      'time': time.toUtc().toString(),
      'desc': desc
    };
  }
  
  Map toDB(){
    return {
      '_id': time.toUtc(),
      'desc': desc
    };
  }
}