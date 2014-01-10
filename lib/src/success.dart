part of ompa_common;

class Success extends Model{
  
  Success(data):super(data);
  
  factory Success.formJson(Map json){
    var data = {'time' : DateTime.parse(json['time'])};
    if(json.containsKey('desc')){
      data['desc'] = json['desc'];
    }
    return new Success(data);
  }
  
  DateTime get time => data['time'];
  set time(DateTime value) => data['time'] = value;
  
  String get desc => data['desc'];
  set desc(String value) => data['desc'] = value;
  
  Object toJson(){
    Map json = new Map.from(data);
    json['time'] = json['time'].toString();
    return json;
  }
}