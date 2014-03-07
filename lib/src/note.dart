part of ompa_common;

class Note extends Model{
  String name = '';
  int sort = 0;
  String text = '';
  
  ObjectId _id = new ObjectId();
  
  Note();

  factory Note.fromJson(json){
    if(json is String){
      json = JSON.decode(json);
    }
    var model = new Note();
    model.name = json['name'];
    model.text = json['text'];
    model._id = new ObjectId.fromHexString(json['_id']);
    model.sort = json['sort']; 
    return model;
  }
  
  factory Note.fromDb(Map data){
    var model = new Note();
    if(data.containsKey('name')){
      model._id = data['_id'];
      model.name = data['name'];
    }else{
      model.name = data['_id'];
    }
    model.text = data['text'];
    if(data.containsKey('sort')){
      model.sort = data['sort'];
    }
    return model;
  }
  
  Map toJson(){
    return {
      '_id': _id.toHexString(),
      'name': name,
      'sort': sort,
      'text': text
    };
  }
  
  Map toDb(){
    return {
      '_id': _id,
      'name': name,
      'sort': sort,
      'text': text
    };
  }
}