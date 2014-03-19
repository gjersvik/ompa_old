part of ompa_html;

class TaskServiceRest extends TaskService{
  Server _server;
  TaskServiceRest(this._server);

  Future<Task> complete(Task task) {
    return _server.putJson('task/complete', task.toMap())
        .then((data) => new Task.fromMap(data));
  }

  Future<List<Task>> getAll() {
    return _server.getJson('task').then((List n){
      return n.map((Map json) => new Task.fromMap(json)).toList();
    });
  }

  Future<Task> remove(Task task) {
    return _server.deleteJson('task', task.toMap()).then((_)=> task);
  }

  Future<Task> save(Task task) {
    return _server.putJson('task', task.toMap()).then((_)=> task);
  }
}