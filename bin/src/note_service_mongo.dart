part of ompa;

class NoteServiceMongo extends NoteService{
  DbCollection _db;
  NoteServiceMongo(Db db){
    _db = db.collection('note');
  }
 
  Future<List<Note>> getAll(){
    return _db.find(where.sortBy('sort')).stream.map(_fromDb).toList();
  }
  
  Future<Note> save(Note note) {
    return _db.update({'_id': note.id}, _toDb(note), upsert: true)
        .then((_) => note);
  }
  
  Future remove(Note note) => _db.remove({'_id': note.id}).then((_) => note);
  
  Note _fromDb(Map data) => new Note(fromMongo(data));
  Map _toDb(Note note) => toMongo(note.toJson());
}