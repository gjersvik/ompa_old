part of ompa_html;

class Box {
  final DivElement box = new DivElement();
  final DivElement content = new DivElement();
  
  Box(){
    box.classes.add('box');
    content.classes.add('content');
    box.append(content);
  }
}