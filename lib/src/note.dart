part of ompa_common;

class Note extends Model{
  String name = '';
  String text = '';
  
  Note();

  factory Note.formJson(json){
    if(json is String){
      json = JSON.decode(json);
    }
    var model = new Note();
    model.name = DateTime.parse(json['name']);
    model.text = json['text'];
    return model;
  }
  
  factory Note.formDb(Map data){
    var model = new Note();
    model.name = data['_id'];
    model.text = data['text'];
    return model;
  }
  
  Map toJson(){
    return {
      'name': name,
      'text': text
    };
  }
  
  Map toDb(){
    return {
      '_id': name,
      'text': text
    };
  }
}