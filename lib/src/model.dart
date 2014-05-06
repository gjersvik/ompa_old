part of ompa_common;

class Model {
  final Map<String,dynamic> json = {};
  Model([Map data]){
    if(data != null){
      json.addAll(data);
    }
  }
  
  Map<String,dynamic> toJson() => new Map.from(json);
  
  String toString() => JSON.encode(this);
}