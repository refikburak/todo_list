import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:todo_list/data/di/locator.dart';
import 'package:todo_list/data/model/note.dart';
import 'package:todo_list/data/repositories/note_repository_interface.dart';

class NoteDetailPage extends StatefulWidget {
  const NoteDetailPage({super.key, required this.note});
  final Note note;

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final _titleController = TextEditingController();
  INoteRepository noteRepository = getIt<INoteRepository>();
  late QuillController _controller;

  @override
  void initState() {
    _controller = QuillController(
      selection: const TextSelection.collapsed(offset: 0),
      document: Document()..insert(0, widget.note.description),
    );
    super.initState();
  }

  final snackBar = SnackBar(
    content: Text('Deleted note successfully!'),
  );
  @override
  Widget build(BuildContext context) {
    _titleController.text = widget.note.name;
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
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Are you sure?"),
                        content: const Text(
                            "Are you sure you want to delete this note?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              noteRepository.delete(widget.note);
                              Navigator.of(context).pop();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            child: const Text("Delete"),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(
                Icons.delete_outline_rounded,
                size: 30,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              onPressed: () {
                noteRepository.update(
                  Note(
                    id: widget.note.id,
                    name: _titleController.text,
                    description: _controller.document.toPlainText(),
                  ),
                );
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: QuillEditor.basic(controller: _controller, readOnly: false),
          ),
        ],
      ),
    );
  }
}
