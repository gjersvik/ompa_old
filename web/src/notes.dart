part of ompa_html;

class Notes{
  final DivElement elem = new DivElement();
  
  final Server _server;
  
  final DivElement _newNote = new DivElement();
  final TextInputElement _textbox = new TextInputElement();
  ButtonElement _create = new ButtonElement();
  
  Notes(this._server){
    elem.className = 'notes';
    _create.text = 'Create new note';
    _create.onClick.listen((MouseEvent e){
      if(e.button != 0 || _textbox.value == ''){
        return;
      }
      add(new Note(_textbox.value,'',_server));
      _textbox.value = '';
    });
    
    _newNote.className = 'newNote';
    _newNote.append(_textbox);
    _newNote.append(_create);
    
    elem.append(_newNote);
    _server.getJson('note').then((List notes){
      notes.forEach((Map note){
        add(new Note(note['name'],note['text'],_server));
      });
    });
  }
  
  add(Note note){
    elem.append(note.elem);
  }
}
