part of ompa_html;

class SuccessPanel extends Panel{
  
  Stream onNext;
  Stream onPrev;
  Stream<String> onAdd;
  
  SuccessPanel():super(){
    var prev = new ButtonElement();
    prev.text = '<';
    prev.className = 'prev';
    onPrev = prev.onClick.where((e) => e.button == 0);
    var next = new ButtonElement();
    next.text = '>';
    next.className = 'next';
    onNext = next.onClick.where((e) => e.button == 0);
    
    var date = new SpanElement();
    date.text = '1. January 2014';
    
    var header = new DivElement();
    header.className = 'top';
    header.append(prev);
    header.append(date);
    header.append(next);
    
    
    var textbox = new InputElement(type: 'text');
    var add = new ButtonElement();
    add.text = 'Add';
    onAdd = add.onClick.where((e) => e.button == 0).map((_){
      var text = textbox.value;
      textbox.value = '';
      return text;
    });
    
    var fotter = new DivElement();
    fotter.className = 'bottom';
    fotter.append(textbox);
    fotter.append(add);
    
    content.classes.add('success');
    content.append(header);
    content.append(fotter);
  }
}