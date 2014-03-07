part of ompa_common;

abstract class NoteService{
  Future<List<Note>> getAll();
  Future<Note> save(Note);
  Future remove(Note);
}