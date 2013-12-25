import 'dart:html';

class Note{
  final DivElement elem = new DivElement();
  
  String title;
  String _text = '';
  bool edit = false;
  Note(this.title){
    elem.className = 'note';
    elem.onClick.listen(click);
    var id = Uri.encodeComponent(title);
    HttpRequest.getString('http://127.0.0.1:8080/note/$id')
    .then((String text) {
      _text = text;
      render();
    })
    .catchError(print);
  }
  
  click(MouseEvent e){
    if(e.button != 0){
      return;
    }
    if(edit){
      if(e.target is ButtonElement){
        title = elem.querySelector('input').value;
        _text = elem.querySelector('textarea').value;
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
      s.writeln('<textarea>$_text</textarea>');
      s.writeln('<button>Save</button>');
    }else{
      s.writeln('<h1>$title</h1>');
      s.writeln('<pre>$_text</pre>');
    }
    elem.innerHtml = s.toString();
  }
  
  
}

void main() {
  document.body.append(new Note('SuperNote').elem);
}
