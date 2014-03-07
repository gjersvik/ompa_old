part of ompa_html;

@NgController( selector: '[ompa-task]', publishAs: 'OmpaTask')
class TaskController{
  List<Task> tasks = [];
  String newTask = '';
  String newTasks = '';
  
  TaskService _service;
  TaskController(this._service){
    _service.getAll().then((t) =>tasks = t);
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
      var task = new Task()..name = name;
      tasks.add(task);
      _service.save(task);
    });
    newTasks = '';
  }
  
  remove(Task task){
    _service.remove(task).then(tasks.remove);
  }
  
  complete(Task task){
    _service.complete(task).then(tasks.remove);
  }
}