part of ompa_common;

class Model {
  final Map data;
  Model(this.data);
  
  Map toJSON(){
    return data;
  }
  Map toDB(){
    return data;
  }
}