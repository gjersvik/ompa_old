part of ompa_common;

abstract class NoteService{
  Future<Note> get(String name);
  Future<List<Note>> getAll();
  Future<Note> save(Note);
  Future remove(Note);
}