part of ompa_html;

class Tasks {
  
  Tasks(Element parent){
    Element tasks = new DivElement();
    tasks.className = 'tasks';
    tasks.appendHtml('<h1>Tasks</h1>');
    tasks.appendHtml('<ul></ul>');
    tasks.appendHtml('<input type="text"/><button>Add</button>');
    
    
    parent.append(tasks);
  }
}