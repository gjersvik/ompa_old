part of ompa_html;

@NgController( selector: '[ompa-task]', publishAs: 'OmpaTask')
class TaskController{
  Set<Task> tasks;
  String newTask = '';
  String newTasks = '';
  
  TaskService _service;
  TaskController(this._service){
    tasks = new SplayTreeSet(_compare);
    _service.getAll().then((t) =>tasks.addAll(t));
  }
  
  add(){
    var task = new Task();
    task.name = newTask;
    newTask = '';
    tasks.add(task);
    _service.save(task);
  }
  
  addMany(){
    newTasks.split('\n').forEach((String name){
      var task = new Task();
      task.name = name;
      tasks.add(task);
      _service.save(task);
    });
    newTasks = '';
  }
  
  remove(Task task){
    _service.remove(task).then((_) =>tasks.remove(task));
  }
  
  complete(Task task){
    _service.complete(task).then((_) =>tasks.remove(task));
  }
  
  _compare(Task a, Task b){
    return a.name.compareTo(b.name);
  }
}