part of ompa_common;

abstract class NoteService{
  Future<Note> get(String name);
  Stream<Note> getAll();
  Future<Note> save(Note);
}