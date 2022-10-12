import 'package:get_storage/get_storage.dart';
import 'package:todo_list/data/di/locator.dart';
import 'package:injectable/injectable.dart' as injectable;
import 'package:todo_list/data/model/note.dart';

import 'dart:core';

import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/data/repositories/note_repository_interface.dart';

void main() {
  late INoteRepository noteRepository;
  setUpAll(() async {
    await setupDI(injectable.Environment.prod);
    noteRepository = getIt<INoteRepository>();
  });

  var item = Note(id: 1, name: "Item", description: "Açıklama Item");
  var item2 = Note(id: 2, name: "Item2", description: "Açıklama Item2");

  var itemNew =
      Note(id: 1, name: "Item Yeni", description: "Açıklama Item Yeni");
  test(
    "Add Test",
    (() async {
      noteRepository.add(item);
      expect(noteRepository.getAll().contains(item), true);
    }),
  );
  test(
    "Update Test",
    (() async {
      noteRepository.update(itemNew);
      var index = noteRepository.getAll().indexOf(itemNew);
      print("index = $index");
      print("notes length ${noteRepository.getAll().length}");
      if (index != -1) {
        print("update test index -1 değil");
        expect(noteRepository.getAll()[index].name, itemNew.name);
      } else {
        throw Exception("Hata");
      }
    }),
  );
  test(
    "Delete Test",
    (() async {
      noteRepository.update(itemNew);
      noteRepository.add(item2);
      noteRepository.delete(itemNew);
      expect(noteRepository.getAll().contains(itemNew), false);
    }),
  );
}
