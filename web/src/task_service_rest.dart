part of ompa_html;

class TaskServiceRest extends TaskService{
  Server _server;
  List<Task> _allTasks = [];
  Future _loaded;
  
  TaskServiceRest(this._server){
    _loaded = _server.getJson('task').then((List n){
      return n.map((Map json) => new Task(json)).toList();
    }).then(_allTasks.addAll);
  }

  Future<Task> complete(Task task) {
    task = _allTasks.firstWhere((t) => t.id == task.id);
    _allTasks.remove(task);
    fireChange(task, null);
    return _server.putJson('task/complete', task.toJson())
        .then((data) => new Task(data));
  }

  Future<List<Task>> getAll() => _loaded.then((_) => _allTasks);

  Future<Task> remove(Task task) {
    return _loaded.then((_){
      task = _allTasks.firstWhere((t) => t.id == task.id);
      _allTasks.remove(task);
      fireChange(task, null);
      _server.deleteJson('task', task.toMap());
      
      return task;
    });
  }

  Future<Task> save(Task task) {
    if(task.id.isEmpty){
      return create(task);
    }else{
      return update(task);
    }
  }
  
  Future<Task> create(Task task){
    return _loaded.then((_) {
      return _server.putJson('task', task.toMap()).then((json){
        var newTask = new Task(json);
        _allTasks.add(newTask);
        fireChange(null, newTask);
        return newTask;
      });
    });
  }
  
  Future<Task> update(Task task){
    return _loaded.then((_){
      var from = _allTasks.firstWhere((t) => t.id == task.id);
      _allTasks.remove(from);
      _allTasks.add(task);
      fireChange(from, task);
      _server.putJson('task', task.toJson());
      return task;
    });
  }
}