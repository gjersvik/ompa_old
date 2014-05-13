part of ompa_common;

class Task extends Model{
  final Map<String, dynamic> json = {
    'id': '',
    'name': '',
    'startTime': new DateTime.now().toUtc().toString(),
    'duration': 0,
  };
  
  Task([Map data]): super(data){
    _startTime = DateTime.parse(json['startTime']);
    if(json['endtime'] != null){
      _endTime = DateTime.parse(json['endTime']);
    }
    _duration = new Duration(seconds: json['duration']);
  }
  
  String get id => json['id'];
  set id(String id) => json['id'] = id;
  
  String get name => json['name'];
  set name(String name) => json['name'] = name;
  
  DateTime get startTime => _startTime;
  set startTime(DateTime time){
    _startTime = time.toUtc();
    json['startTime'] = _startTime.toString();
  }
  
  DateTime get endTime => _endTime;
  set endTime(DateTime endTime){
    if(endTime == null){
      json.remove('endTime');
      _endTime == null;
    }else{
      _endTime = endTime.toUtc();
      json['endTime'] = _endTime.toString();
    }
  }
  
  Duration get duration => _duration;
  set duration(Duration duration){
    _duration = duration;
    json['duration'] = duration.inSeconds;
  }
  
  toMap() => json;
  
  DateTime _startTime = null;
  DateTime _endTime = null;
  Duration _duration = null;
}