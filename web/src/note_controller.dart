part of ompa_html;

@Controller( selector: '[ompa-note]', publishAs: 'OmpaNote')
@Injectable()
class NoteController{
  final NoteService _service;
  
  String newNote = '';
  List<Note> notes = [];
  
  NoteController(this._service){
    _service.getAll().then((List n) => notes = n);
  }
  
  save(Note note){
    _service.save(note);
  }
  
  delete(Note note) => _service.remove(note).then(notes.remove);
  
  prev(Note note){
    if(note == notes.first){
      return;
    }
    int i = notes.indexOf(note);
    swap(i, i - 1);
  }
  
  next(Note note){
    if(note == notes.last){
      return;
    }
    int i = notes.indexOf(note);
    swap(i, i + 1);
  }
  
  swap(int i1, int i2){
    notes[i1].sort = i2;
    notes[i2].sort = i1;
    
    var temp = notes[i1];
    notes[i1] = notes[i2];
    notes[i2] = temp;
    
    save(notes[i1]);
    save(notes[i2]);
  }
  
  add(){
    var note = new Note();
    note.name = newNote;
    notes.add(note);
    newNote = null;
  }
}
