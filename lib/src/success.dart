part of ompa_common;

class Success extends Model{
  
  Success(data):super(data);
  
  factory Success.formJson(String jsonstring){
    var json = JSON.decode(jsonstring);
    var data = {};
    
    if(json.containsKey('time')){
      data['time'] = DateTime.parse(json['time']);
    }else{
      data['time'] = new DateTime.now().toUtc();
    }
    if(json.containsKey('desc')){
      data['desc'] = json['desc'];
    }
    return new Success(data);
  }
  
  DateTime get time => data['time'];
  set time(DateTime value) => data['time'] = value.toUtc();
  
  String get desc => data['desc'];
  set desc(String value) => data['desc'] = value;
  
  Map toJson(){
    Map json = new Map.from(data);
    json['time'] = json['time'].toString();
    return json;
  }
  
  Map toDB(){
    var db = {};
    db['_id'] = db['time'];
    
    if(data.containsKey('desc')){
      db['desc'] = db['desc'];
    }
    
    return db;
  }
}