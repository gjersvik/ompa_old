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
    var data = _toDb(note);
    return _db.update({'_id': data['_id']}, data, upsert: true)
        .then((_) => _fromDb(data));
  }
  
  Future remove(Note note){
    var id = _toDb(note)['_id'];
    return _db.remove({'_id': id}).then((_) => note);
  }
  
  Note _fromDb(Map data) => new Note(fromMongo(data));
  Map _toDb(Note note) => toMongo(note.toJson());
}