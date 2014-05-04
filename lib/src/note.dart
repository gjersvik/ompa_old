part of ompa_common;

class Note extends Model{
  final json = {
    'name': '',
    'sort': 0,
    'text': ''
  };
  
  Note([Map data]):super(data);
  
  String get id => json['id'];
  set id(String id) => json['id'] = id;
  
  String get name => json['name'];
  set name(String name) => json['name'] = name;
  
  int get sort => json['sort'];
  set sort(int sort) => json['sort'] = sort;
  
  String get text => json['text'];
  set text(String text) => json['text'] = text;
}