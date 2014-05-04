part of ompa_common;

class Model {
  final Map<String,dynamic> json = {};
  Model([Map data]){
    if(data != null){
      json.addAll(data);
    }
  }
  
  Map<String,dynamic> toJson() => json;
  
  String toString() => JSON.encode(this);
}