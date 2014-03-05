part of ompa_html;

@NgController( selector: '[ompa-note]', publishAs: 'OmpaNote')
class NoteController{
  final Server _server;
  
  String newNote = '';
  List<Note> notes = [];
  
  NoteController(this._server){
    _server.getJson('note').then((List n){
      notes = n.map((Map json) => new Note.fromJson(json)).toList();
    });
  }
  
  save(Note note){
    _server.put('note', note.toString());
  }
  
  delete(Note note){
    _server.delete('note', note.toString())
      .then((_){
        notes.remove(note);
      });
  }
  
  add(){
    var note = new Note();
    note.name = newNote;
    notes.add(note);
    newNote = null;
  }
}
