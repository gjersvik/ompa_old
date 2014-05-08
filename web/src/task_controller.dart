part of ompa_html;

@NgController( selector: '[ompa-task]', publishAs: 'OmpaTask')
class TaskController{
  Set<Task> tasks;
  String newTask = '';
  String newTasks = '';
  
  TaskService _service;
  TaskController(this._service){
    tasks = new SplayTreeSet<Task>(_compare, _valid);
    _service.getAll().then((t) =>tasks.addAll(t));
    _service.onChange.listen((ChangeEvent event){
      if(event.from != null){
        var task = tasks.firstWhere((t) => t.id == event.from.id);
        tasks.remove(task);
      }
      if(event.to != null){
        tasks.add(event.to);
      }
    });
  }
  
  add(){
    var task = new Task();
    task.name = newTask;
    newTask = '';
    _service.create(task);
  }
  
  addMany(){
    newTasks.split('\n').forEach((String name){
      var task = new Task();
      task.name = name;
      _service.create(task);
    });
    newTasks = '';
  }
  
  remove(Task task) => _service.remove(task);
  complete(Task task) => _service.complete(task);
  
  _compare(Task a, Task b){
    var comp = a.name.compareTo(b.name);
    if(comp == 0){
      return a.id.compareTo(b.id);
    }
    return comp;
  }
  
  _valid(task) => task is Task;
}