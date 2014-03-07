part of ompa;

class TaskServiceMongo extends TaskService{
  DbCollection _db;
  SuccessServer _success;
  
  TaskServiceMongo(Db db, this._success){
    _db = db.collection('task');
  }
 
  Future<List<Task>> getAll() => _db.find(where.sortBy('name'))
      .stream.map((json) => new Task.fromJson(json)).toList();
  
  Future<Task> save(Task task) {
    return _db.update({'_id': task.id}, task.toDb(), upsert: true)
        .then((_) => task);
  }
  
  Future<Task> remove(Task task) => _db.remove({'_id': task.id})
      .then((_) => task);

  Future<Task> complete(Task task) {
    var success = new Success();
    success.desc = task.name;
    return remove(task).then((_) => _success.save(success)).then((_) => task);
  }
}