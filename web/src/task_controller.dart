part of ompa_html;

@NgController( selector: '[ompa-task]', publishAs: 'OmpaTask')
class TaskController{
  List<Task> tasks = [];
  String newTask = '';

  TaskController(){}
  
  add(){
    var task = new Task();
    task.name = newTask;
    newTask = '';
    tasks.add(task);
  }
  
  remove(Task task){
    tasks.remove(task);
  }
  
  complete(Task task){
    tasks.remove(task);
  }
}