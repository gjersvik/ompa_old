part of ompa;

class TaskServiceMongo extends TaskService{
  DbCollection _db;
  SuccessService _success;
  List<Task> _allTasks = [];
  Future _loaded;
  
  TaskServiceMongo(Db db, this._success){
    _db = db.collection('task');
    _loaded = _db.find().stream.map(_fromDb).toList().then(_allTasks.addAll);
  }
 
  Future<List<Task>> getAll() => _loaded.then((_) => _allTasks);
  
  Future<Task> save(Task to) {
    return _loaded.then((_){
      Task from = null;
      if(to.id.isNotEmpty){
        from = _allTasks.firstWhere((t) => t.id == to.id);
        _allTasks.remove(from);
      }else{
        to = _fromDb(_toDb(to));
      }
      _allTasks.add(to);
      fireChange(from, to);
      
      var mongo = _toDb(to);
      // no return of future call on puproce database is backup.
      _db.update({'_id': mongo['_id']}, mongo, upsert: true);
      return to;
    });
  }
  
  Future<Task> remove(Task task){
    return _loaded.then((_){
      task = _allTasks.firstWhere((t) => t.id == task.id);
      _allTasks.remove(task);
      fireChange(task, null);
      
      var id = _toDb(task)['_id'];
      _db.remove({'_id': id});
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