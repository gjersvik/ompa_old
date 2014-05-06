part of ompa_common;

class ChangeEvent<T extends Model> {
  final T from;
  final T to;
  
  ChangeEvent(this.from, this.to);
}