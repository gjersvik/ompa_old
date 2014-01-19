part of ompa_html;

class Tasks {
  
  Tasks(Element parent){
    Element tasks = new DivElement();
    tasks.className = 'tasks';
    parent.append(tasks);
  }
}