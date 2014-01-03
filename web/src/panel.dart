part of ompa_html;

class Panel {
  final DivElement panel = new DivElement();
  final DivElement content = new DivElement();
  
  Panel(){
    panel.classes.add('panel');
    content.classes.add('content');
    panel.append(content);
  }
}