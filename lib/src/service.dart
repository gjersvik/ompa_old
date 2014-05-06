part of ompa_common;

class Service<T extends Model> {
  Stream<ChangeEvent<T>> get onChange => _sink.stream;
  
  fireChange(T from, T to) => _sink.add(new ChangeEvent(from, to));
  
  StreamController<ChangeEvent<T>> _sink = new StreamController.broadcast();
}