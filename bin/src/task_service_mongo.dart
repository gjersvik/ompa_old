part of ompa;

class TaskServiceMongo extends TaskService{
  DbCollection _db;
  SuccessServer _success;
  
  TaskServiceMongo(Db db, this._success){
    _db = db.collection('task');
  }
 
  Future<List<Task>> getAll() => _db.find(where.sortBy('name'))
      .stream.map(fromMongo).map((d) => new Task.fromMap(d)).toList();
  
  Future<Task> save(Task task) {
    var mongo = toMongo(task.toMap());
    return _db.update({'_id': mongo['_id']}, mongo, upsert: true)
        .then((_) => new Task.fromMap(fromMongo(mongo)));
  }
  
  Future<Task> remove(Task task){
    var mongo = toMongo(task.toMap());
    return _db.remove({'_id': mongo['_id']}).then((_) => task);
  }

  Future<Task> complete(Task task) {
    var success = new Success();
    success.desc = task.name;
    return remove(task).then((_){_success.save(success);});
  }
}