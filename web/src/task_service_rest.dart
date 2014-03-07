part of ompa_html;

class TaskServiceRest extends TaskService{
  Server _server;
  TaskServiceRest(this._server);

  Future<Task> complete(Task task) {
    return _server.put('task/complete', task.toString()).then((_)=> task);
  }

  Future<List<Task>> getAll() {
    return _server.getJson('task').then((List n){
          return n.map((Map json) => new Task.fromJson(json)).toList();
        });
  }

  Future<Task> remove(Task task) {
    return _server.delete('task', task.toString()).then((_)=> task);
  }

  Future<Task> save(Task task) {
    return _server.put('task', task.toString()).then((_)=> task);
  }
}