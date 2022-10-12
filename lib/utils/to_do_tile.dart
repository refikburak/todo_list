import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/data/model/note.dart';
import 'package:todo_list/pages/note_detail_page.dart';

class ToDoTile extends StatefulWidget {
  final Note note;
  const ToDoTile({super.key, required this.note});

  @override
  State<ToDoTile> createState() => _ToDoTileState();
}

class _ToDoTileState extends State<ToDoTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
                builder: (context) => NoteDetailPage(note: widget.note)),
            (route) => true);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: const Color.fromARGB(160, 82, 45, 168),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.note.name,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Text(
              widget.note.description ?? "",
              maxLines: 3,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}
