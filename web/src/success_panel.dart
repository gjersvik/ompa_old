part of ompa_html;

class SuccessPanel extends Panel{
  SuccessPanel():super(){
    var prev = new ButtonElement();
    prev.text = '<';
    prev.className = 'prev';
    var next = new ButtonElement();
    next.text = '>';
    next.className = 'next';
    
    var date = new SpanElement();
    date.text = '1. January 2014';
    
    var header = new DivElement();
    header.className = 'top';
    header.append(prev);
    header.append(date);
    header.append(next);
    
    content.classes.add('success');
    content.append(header);
  }
}