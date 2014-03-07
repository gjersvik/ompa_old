part of ompa_common;

abstract class TaskService{
  Future<List<Task>> getAll();
  Future<Task> save(Task task);
  Future<Task> complete(Task task);
  Future<Task> remove(Task task);
}