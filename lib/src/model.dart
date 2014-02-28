part of ompa_common;

abstract class Model {
  Map toJson();
  Map toDb();
  
  String toString() => JSON.encode(this);
}