part of ompa_common;

class Model2 {
  final Map<String,dynamic> json = {};
  Model2([Map data]){
    if(data != null){
      json.addAll(data);
    }
  }
  
  Map<String,dynamic> toJson() => json;
  
  String toString() => JSON.encode(this);
}