part of ompa_common;

abstract class TaskService{
  Future<List<Task>> getAll();
  Future<Task> save(Task);
  Future<Task> complete(Task);
  Future<Task> remove(Task);
}