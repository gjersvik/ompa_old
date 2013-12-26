import 'dart:html';

class Note{
  final DivElement elem = new DivElement();
  
  final String title;
  
  String _text = '';
  ButtonElement _save = new ButtonElement();
  HeadingElement _title = new HeadingElement.h1();
  TextAreaElement _textbox =  new TextAreaElement();
  
  Note(this.title){
    elem.className = 'note';
    elem.append(_title);
    elem.append(_textbox);
    elem.append(_save);
    
    _save.text = 'Save';
    _save.onClick.listen((MouseEvent e) => e.button != 0 ? save(): null);
    
    _title.text = title;
    
    HttpRequest.getString(uri)
    .then((String text) {
      _text = text;
      _textbox.value = text;
    })
    .catchError(print);
  }
  
  String get uri {
    var id = Uri.encodeComponent(title);
    return 'http://127.0.0.1:8080/note/$id';
  }
  
  save(){
    var text = _textbox.value;
    if(text == _text){
      return;
    }
    
    HttpRequest.request(uri, method: 'PUT', sendData: text)
      .then((_){
        _text = text;
      })
      .catchError(print);
  }
}

void main() {
  document.body.append(new Note('SuperNote').elem);
}
