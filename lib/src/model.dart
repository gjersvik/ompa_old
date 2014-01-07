part of ompa_common;

class Model {
  final name = 'model';
  final Map data;
  Model(this.data);
  
  Map toJSON(){
    return data;
  }
  Map toDB(){
    return data;
  }
}