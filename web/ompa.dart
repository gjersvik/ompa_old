import 'dart:html';

class Note{
  final Element elem;
  
  String title = 'Temp title';
  String text = 'Bla bla bla bla';
  bool edit = false;
  Note(this.elem){
    elem.onClick.listen(click);
    render();
  }
  
  click(MouseEvent e){
    if(e.button != 0){
      return;
    }
    if(edit){
      if(e.target is ButtonElement){
        title = elem.querySelector('input').value;
        text = elem.querySelector('textarea').value;
        edit = false;
        render();
      }
    }else{
      edit = true;
      render();
    }
  }
  
  render(){
    var s = new StringBuffer();
    if(edit){
      s.writeln('<input type="text" value="$title">');
      s.writeln('<textarea>$text</textarea>');
      s.writeln('<button>Save</button>');
    }else{
      s.writeln('<h1>$title</h1>');
      s.writeln('<pre>$text</pre>');
    }
    elem.innerHtml = s.toString();
  }
  
  
}

void main() {
  new Note(querySelector('#note'));
}
