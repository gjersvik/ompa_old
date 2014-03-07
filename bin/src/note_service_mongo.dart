part of ompa;

class NoteServiceMongo extends NoteService{
  DbCollection _db;
  NoteServiceMongo(Db db){
    _db = db.collection('note');
  }
 
  Future<List<Note>> getAll() => _db.find().stream.map(_toNote).toList();
  
  Future<Note> save(Note note) {
    return _db.update({'_id': note.name}, note.toDb(), upsert: true)
        .then((_) => note);
  }
  
  Future remove(Note note) => _db.remove({'_id': note.id});
  
  Note _toNote(Map data) => new Note.fromDb(data);
}