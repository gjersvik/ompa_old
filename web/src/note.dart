part of ompa_html;

class Note{
  final DivElement elem = new DivElement();
  
  final String title;
  
  final Server _server;
  String _text = '';
  ButtonElement _save = new ButtonElement();
  HeadingElement _title = new HeadingElement.h1();
  TextAreaElement _textbox =  new TextAreaElement();
  
  Note(this.title, this._text,this._server){
    _init();
    _textbox.value = _text;
  }
  
  Note.load(this.title,this._server){
    _init();
    _server.get('note/$title')
      .then((String text) {
        _text = text;
        _textbox.value = text;
      })
        .catchError(print);
  }
  
  save(){
    var text = _textbox.value;
    if(text == _text){
      return;
    }
    _save.text = 'Saveing...';
    _server.put('note/$title', text)
      .then((_){
        _text = text;
        _save.text = 'Save';
      })
      .catchError(print);
  }
  
  _init(){
    elem.className = 'note';
    elem.append(_title);
    elem.append(_textbox);
    elem.append(_save);
    
    _save.text = 'Save';
    _save.onClick.listen((MouseEvent e) => e.button == 0 ? save(): null);
    
    _title.text = title;
  }
}
