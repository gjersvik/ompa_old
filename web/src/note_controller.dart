part of ompa_html;

class NoteController{
  final Server _server;
  final Panels _panels;
  
  final NewNotePanel _newNote = new NewNotePanel();
  
  final TextInputElement _textbox = new TextInputElement();
  final ButtonElement _create = new ButtonElement();
  
  NoteController(this._server, this._panels){
    _newNote.onNewNote.listen((name) => newNote(name,''));
    _panels.add(_newNote);
    
    _server.getJson('note').then((List notes){
      notes.forEach((Map note) => newNote(note['name'],note['text']));
    });
  }
  
  save(NotePanel note){
    var n =  new Note();
    n.name = note.title;
    n.text = note.note;
    _server.put('note/${note.title}', n.toString())
      .then((_){
        note.saveDone();
      });
  }
  
  delete(NotePanel note){
    var n =  new Note();
        n.name = note.title;
        n.text = note.note;
    _server.delete('note', n.toString())
      .then((_){
        _panels.remove(note);
      });
  }
  
  newNote(name,note){
    var panel = new NotePanel(name,note);
    panel.onSave.listen(save);
    panel.onDelete.listen(delete);
    _panels.add(panel);
  }
}
