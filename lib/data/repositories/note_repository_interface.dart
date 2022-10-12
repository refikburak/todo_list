import '../model/note.dart';

abstract class INoteRepository {
  List<Note> getAll();
  Future<void> add(Note model);
  Future<void> update(Note model);
  Future<void> delete(Note model);
  Future<void> deleteAll();
  Stream<List<Note>> getAllListen();
}
