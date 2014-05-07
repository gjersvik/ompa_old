part of ompa_common;

abstract class TaskService extends Service<Task>{
  Future<List<Task>> getAll();
  Future<Task> save(Task task);
  Future<Task> complete(Task task);
  Future<Task> remove(Task task);
  
  Future<Task> create(Task task) => save(task);
  Future<Task> update(Task task) => save(task);
  Future<Task> nextApointment() => getAll().then((l) => l.first);
  Future<List<Task>> topTasks() => getAll().then((l) => l.take(3).toList());
}