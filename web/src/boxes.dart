part of ompa_html;

class Boxes{
  final elem = new DivElement();
  
  Boxes(){
    elem.className = 'boxes';
  }
  
  add(Box box){
    elem.append(box.box);
  }
  
  remove(Box box){
    box.box.remove();
  }
}