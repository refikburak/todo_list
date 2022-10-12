import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:todo_list/data/di/locator.dart';
import 'package:todo_list/data/model/note.dart';
import 'package:todo_list/data/model/task.dart';
import 'package:todo_list/data/repositories/note_repository_interface.dart';
import 'package:todo_list/utils/task_tile.dart';

class CreateNotePage extends StatelessWidget {
  const CreateNotePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    late INoteRepository noteRepository;
    noteRepository = getIt<INoteRepository>();
    List<Note> notes = noteRepository.getAll();
    final QuillController _controller = QuillController.basic();
    final _titleController = new TextEditingController();
    _titleController.text = "New Title";
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 16, 17, 23),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.delete_outline_rounded,
                size: 30,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              onPressed: () {
                (noteRepository.add(
                  Note(
                    id: notes.length == 0 ? 1 : notes[notes.length - 1].id + 1,
                    name: _titleController.text,
                    description: _controller.document.toPlainText(),
                  ),
                ));
                print("pressed ok");
                print(noteRepository.getAll().length);
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.task_alt_rounded,
                size: 30.0,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              color: Colors.transparent,
              child: TextField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  hintText: "Title here",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                border: const Border(
                  left: BorderSide(
                    width: 8.0,
                    color: Color.fromARGB(255, 81, 45, 168),
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child:
                  QuillEditor.basic(controller: _controller, readOnly: false)),
        ],
      ),
    );
  }
}
