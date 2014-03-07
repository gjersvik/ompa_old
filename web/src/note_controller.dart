part of ompa_html;

@NgController( selector: '[ompa-note]', publishAs: 'OmpaNote')
class NoteController{
  final NoteService _service;
  
  String newNote = '';
  List<Note> notes = [];
  
  NoteController(this._service){
    _service.getAll().then((List n) => notes = n);
  }
  
  save(Note note) => _service.save(note);
  
  delete(Note note) => _service.remove(note).then(notes.remove);
  
  add(){
    var note = new Note();
    note.name = newNote;
    notes.add(note);
    newNote = null;
  }
}
