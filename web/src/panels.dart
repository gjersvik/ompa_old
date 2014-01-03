part of ompa_html;

class Panels{
  final elem = new DivElement();
  
  Panels(){
    elem.className = 'panels';
  }
  
  add(Panel panel){
    elem.append(panel.panel);
  }
  
  remove(Panel panel){
    panel.panel.remove();
  }
}