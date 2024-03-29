part of ompa_common;

class Success extends Model{
  final Map json = {
    'desc': '',
    'time': new DateTime.now().toUtc().toString(),
    'meta': {}
  };
  
  Success([Map data]):super(data){
    _time = DateTime.parse(json['time']);
  }
  
  String get id => json['id'];
  set id(String id) => json['id'] = id;
  
  String get desc => json['desc'];
  set desc(String desc) => json['desc'] = desc;
  
  DateTime get time => _time;
  set time(DateTime time){
    _time = time.toUtc();
    json['time'] = _time.toString();
  }
  
  Map get meta => json['meta'];
  set meta(Map meta) => json['meta'] = new Map.from(meta);
  
  DateTime _time;
}