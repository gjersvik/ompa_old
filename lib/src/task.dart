part of ompa_common;

class Task extends Model{
  final Map<String, dynamic> json = {
    'id': '',
    'name': '',
    'startTime': new DateTime.now().toUtc().toString(),
    'duration': 0,
  };
  
  Task([Map data]): super(data);
  
  String get id => json['id'];
  set id(String id) => json['id'] = id;
  
  String get name => json['name'];
  set name(String name) => json['name'] = name;
  
  DateTime get startTime => DateTime.parse(json['startTime']);
  set startTime(DateTime time) => json['startTime'] = time.toUtc().toString();
  
  DateTime get endTime{
    if(json['endtime'] == null){
      return null;
    }else{
      return DateTime.parse(json['endTime']);
    }
  }
  set endTime(DateTime endTime){
    if(endTime == null){
      json.remove('endTime');
    }else{
      json['endTime'] = endTime.toUtc().toString();
    }
  }
  
  Duration get duration => new Duration(seconds: json['duration']);
  set duration(Duration duration) => json['duration'] = duration.inSeconds;
  
  toMap() => json;
}