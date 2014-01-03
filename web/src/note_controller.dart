part of ompa_html;

class NoteController{
  final Server _server;
  final Panels _panels;
  
  final Panel _newNote = new Panel();
  
  final TextInputElement _textbox = new TextInputElement();
  final ButtonElement _create = new ButtonElement();
  
  NoteController(this._server, this._panels){
    _create.text = 'Create new note';
    _create.onClick.listen((MouseEvent e){
      if(e.button != 0 || _textbox.value == ''){
        return;
      }
      _panels.add(new Note(_textbox.value,'',_server));
      _textbox.value = '';
    });
    
    _newNote.content.classes.add('newNote');
    _newNote.content.append(_textbox);
    _newNote.content.append(_create);
    _panels.add(_newNote);
    
    _server.getJson('note').then((List notes){
      notes.forEach((Map note){
        _panels.add(new Note(note['name'],note['text'],_server));
      });
    });
  }
}
