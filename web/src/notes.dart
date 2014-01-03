part of ompa_html;

class Notes{
  final Server _server;
  final Boxes _boxes;
  
  final Box _newNote = new Box();
  
  final TextInputElement _textbox = new TextInputElement();
  final ButtonElement _create = new ButtonElement();
  
  Notes(this._server, this._boxes){
    _create.text = 'Create new note';
    _create.onClick.listen((MouseEvent e){
      if(e.button != 0 || _textbox.value == ''){
        return;
      }
      _boxes.add(new Note(_textbox.value,'',_server));
      _textbox.value = '';
    });
    
    _newNote.content.classes.add('newNote');
    _newNote.content.append(_textbox);
    _newNote.content.append(_create);
    _boxes.add(_newNote);
    
    _server.getJson('note').then((List notes){
      notes.forEach((Map note){
        _boxes.add(new Note(note['name'],note['text'],_server));
      });
    });
  }
}
