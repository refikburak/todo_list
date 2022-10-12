import 'dart:async';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';

import 'package:todo_list/data/model/note.dart';
import 'package:todo_list/data/repositories/note_repository_interface.dart';

@Environment(Environment.prod)
@Environment(Environment.dev)
@LazySingleton(as: INoteRepository)
class NoteRepositoryImpl implements INoteRepository {
  final GetStorage _storage;

  NoteRepositoryImpl(this._storage) {
    _storage.listenKey('notes', (value) {
      var jsonData = jsonDecode(value);
      _listen.sink.add(jsonData.map<Note>((e) => Note.fromJson(e)).toList());
    });
  }

  @override
  Future<void> add(Note model) {
    var notes = getAll();
    notes.add(model);
    return _storage.write('notes', jsonEncode(notes));
  }

  @override
  Future<void> delete(Note model) {
    var notes = getAll();
    int index = notes.map((e) => e.id).toList().indexOf(model.id);
    if (index != -1) {
      print("deleted");
      notes.removeAt(index);
    }
    return _storage.write('notes', jsonEncode(notes));
  }

  @override
  List<Note> getAll() {
    var results = _storage.read('notes');
    if (results != null) {
      print("Results:${results}");
      List<dynamic> jsonData = jsonDecode(results);
      return jsonData.map<Note>((e) => Note.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<void> update(Note model) {
    var notes = getAll();
    int index = notes.map((e) => e.id).toList().indexOf(model.id);
    if (index != -1) {
      print("updated");
      notes[index] = model;
    }
    return _storage.write('notes', jsonEncode(notes));
  }

  @override
  Future<void> deleteAll() {
    List<Note> notes = [];
    return _storage.write('notes', jsonEncode(notes));
  }

  final StreamController<List<Note>> _listen =
      StreamController<List<Note>>.broadcast();
  @override
  Stream<List<Note>> getAllListen() {
    return _listen.stream;
  }
}

@Environment(Environment.test)
@LazySingleton(as: INoteRepository)
class TestNoteRepositoryImpl implements INoteRepository {
  List<Note> noteList = [];

  @override
  Future<void> add(Note model) async {
    var notes = getAll();
    notes.add(model);
    noteList = notes;
    _listen.sink.add(notes);
    return;
  }

  @override
  Future<void> delete(Note model) async {
    var notes = getAll();
    notes.remove(model);
    noteList = notes;
    _listen.sink.add(notes);
    return;
  }

  @override
  List<Note> getAll() {
    return noteList;
  }

  @override
  Future<void> update(Note model) async {
    var notes = getAll();
    int index = notes.map((e) => e.id).toList().indexOf(model.id);
    if (index != -1) {
      notes[index] = model;
    }
    noteList = notes;
    _listen.sink.add(notes);
    return;
  }

  final StreamController<List<Note>> _listen =
      StreamController<List<Note>>.broadcast();
  @override
  Stream<List<Note>> getAllListen() {
    return _listen.stream;
  }

  @override
  Future<void> deleteAll() async {
    List<Note> notes = [];
    _listen.sink.add(notes);
    return;
  }
}
