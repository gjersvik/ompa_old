part of ompa_common;

class Task{
  Map _data;
  Task([Map data = const{}]): _data = new Map.from(data);
  
  String get id => _data['id'];
  set id(String id) => _data['id'] = id;
  
  String get name => _data['name'];
  set name(String name) => _data['name'];
  
  toMap() => _data;
}