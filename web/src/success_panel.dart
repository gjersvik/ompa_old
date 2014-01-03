part of ompa_html;

class SuccessPanel extends Panel{
  SuccessPanel():super(){
    var prev = new ButtonElement();
    prev.text = '<';
    prev.className = 'prev';
    var next = new ButtonElement();
    next.text = '>';
    next.className = 'next';
    
    
    var header = new DivElement();
    header.append(prev);
    header.append(next);
    
    content.append(header);
  }
}