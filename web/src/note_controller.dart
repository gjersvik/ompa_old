part of ompa_html;

class NoteController{
  final Server _server;
  final Panels _panels;
  
  final NewNotePanel _newNote = new NewNotePanel();
  
  final TextInputElement _textbox = new TextInputElement();
  final ButtonElement _create = new ButtonElement();
  
  NoteController(this._server, this._panels){
    _newNote.onNewNote.listen((name){
      _panels.add(new Note(name,'',_server));
    });
    _panels.add(_newNote);
    
    _server.getJson('note').then((List notes){
      notes.forEach((Map note){
        _panels.add(new Note(note['name'],note['text'],_server));
      });
    });
  }
}
