part of ompa_html;

class NoteServiceRest extends NoteService{
  Server _server;
  NoteServiceRest(this._server);

  Future<List<Note>> getAll() {
    return _server.getJson('note').then((List n){
          return n.map((Map json) => new Note.fromJson(json)).toList();
        });
  }

  Future<Note> remove(Note note) {
    return _server.delete('note', note.toString()).then((_)=> note);
  }

  Future<Note> save(Note note) {
    return _server.put('note', note.toString()).then((_)=> note);
  }
}