import 'dart:html';

class Note{
  final DivElement elem = new DivElement();
  
  String title;
  String _text = '';
  bool edit = false;
  Note(this.title){
    elem.className = 'note';
    elem.onClick.listen(click);
    render();
    
    HttpRequest.getString(uri)
    .then((String text) {
      _text = text;
      render();
    })
    .catchError(print);
  }
  
  String get uri {
    var id = Uri.encodeComponent(title);
    return 'http://127.0.0.1:8080/note/$id';
  }
  
  click(MouseEvent e){
    if(e.target is ButtonElement && e.button != 0){
      _text = elem.querySelector('textarea').value;
      edit = false;
      render();
      save();
    }
  }
  
  render(){
    var s = new StringBuffer();
    s.writeln('<h1>$title</h1>');
    s.writeln('<textarea>$_text</textarea>');
    s.writeln('<button>Save</button>');
    elem.innerHtml = s.toString();
  }
  
  save(){
    HttpRequest.request(uri, method: 'PUT', sendData: _text)
      .catchError(print);
  }
}

void main() {
  document.body.append(new Note('SuperNote').elem);
}
