part of ompa;

class TaskServiceMongo extends TaskService{
  DbCollection _db;
  SuccessService _success;
  
  TaskServiceMongo(Db db, this._success){
    _db = db.collection('task');
  }
 
  Future<List<Task>> getAll() => _db.find(where.sortBy('name'))
      .stream.map(_fromDb).toList();
  
  Future<Task> save(Task task) {
    var mongo = _toDb(task);
    return _db.update({'_id': mongo['_id']}, mongo, upsert: true)
        .then((_) => _fromDb(mongo));
  }
  
  Future<Task> remove(Task task){
    var mongo = _toDb(task);
    return _db.remove({'_id': mongo['_id']}).then((_) => task);
  }

  Future<Task> complete(Task task) {
    var success = new Success();
    success.desc = task.name;
    return remove(task).then((task){
      _success.save(success);
      return task;
    });
  }
  
  Map _toDb(Task t){
    var data = t.toJson();
    data['startTime'] = DateTime.parse(data['startTime']);
    if(data['endTime'] != null){
      data['endTime'] = DateTime.parse(data['endTime']);
    }
    return toMongo(data);
  }
  
  Task _fromDb(Map data){
    data['startTime'] = data['startTime'].toString();
    if(data['endTime'] != null){
      data['endTime'] = data['endTime'].toString();
    }
    return new Task(fromMongo(data));
  }
}