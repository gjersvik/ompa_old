part of ompa_html;

class Note extends Box{
  final String title;
  
  final Server _server;
  String _text = '';
  ButtonElement _save = new ButtonElement();
  ButtonElement _delete = new ButtonElement();
  HeadingElement _title = new HeadingElement.h1();
  TextAreaElement _textbox =  new TextAreaElement();
  
  Note(this.title, this._text,this._server): super(){
    _init();
    _textbox.value = _text;
  }
  
  Note.load(this.title,this._server): super(){
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
      });
  }
  
  delete(){
    _delete.text = 'Deleting';
    _server.delete('note/$title')
      .then((_){
        content.remove();
      });
  }
  
  _init(){
    content.classes.add('note');
    content.append(_title);
    content.append(_textbox);
    content.append(_save);
    content.append(_delete);
    
    _save.text = 'Save';
    _save.className = 'save';
    _save.onClick.listen((MouseEvent e) => e.button == 0 ? save(): null);
    
    _delete.text = 'Delete';
    _delete.className = 'delete';
    _delete.onClick.listen((MouseEvent e) => e.button == 0 ? delete(): null);
    
    _title.text = title;
  }
}
