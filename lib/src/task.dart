part of ompa_common;

class Task extends Model{
  final Map<String, dynamic> json = {
    'name': ''
  };
  
  Task([Map data]): super(data);
  
  String get id => json['id'];
  set id(String id) => json['id'] = id;
  
  String get name => json['name'];
  set name(String name) => json['name'];
  
  toMap() => json;
}