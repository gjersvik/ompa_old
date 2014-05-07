part of ompa;

class TaskServiceMongo extends TaskService{
  Crud _db;
  SuccessService _success;
  List<Task> _allTasks = [];
  Future _loaded;
  
  TaskServiceMongo(Db db, this._success){
    _db = new CrudMongo(db.collection('task'));
    _loaded = _db.readAll().then((list){
      _allTasks.addAll(list.map((m) => new Task(m)));
    });
  }
 
  Future<List<Task>> getAll() => _loaded.then((_) => _allTasks);
  
  Future<Task> save(Task to) {
    return _loaded.then((_){
      Task from = null;
      if(to.id.isNotEmpty){
        from = _allTasks.firstWhere((t) => t.id == to.id);
        _allTasks.remove(from);
      }else{
        to.id = _db.newId();
      }
      _allTasks.add(to);
      fireChange(from, to);
      
      if(from == null){
        _db.create(to.toJson());
      }else{
        _db.update(to.toJson());
      }
      return to;
    });
  }
  
  Future<Task> remove(Task task){
    return _loaded.then((_){
      task = _allTasks.firstWhere((t) => t.id == task.id);
      _allTasks.remove(task);
      fireChange(task, null);
      
      _db.delete(task.toJson());
      return task;
    });
  }

  Future<Task> complete(Task task) {
    var success = new Success();
    success.desc = task.name;
    return remove(task).then((task){ 
      _success.save(success);
      return task;
    });
  }
}