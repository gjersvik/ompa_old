part of ompa_common;

class Task{
  static const EMPTY = const Task();
  
  final String id;
  final String name;
  
  const Task({
    id: '',
    name: ''
  }):id = id,name = name;
  
  factory Task.fromMap(Map data){
    var base = {
      'id': '',
      'name': ''
    };
    base.addAll(data);
    return new Task(
      id: base['id'],
      name: base['name']
    );
  }
  
  Task setName(String name){
    return new Task(
      id: id,
      name: name
    );
  }
  
  Map toMap(){
    return {
      'id': id,
      'name': name
    };
  }
}