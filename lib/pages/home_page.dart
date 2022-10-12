import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/data/di/locator.dart';
import 'package:todo_list/data/model/note.dart';
import 'package:todo_list/data/repositories/note_repository_interface.dart';
import 'package:todo_list/pages/create_note_page.dart';
import 'package:todo_list/utils/to_do_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchTextController = TextEditingController();
  INoteRepository noteRepository = getIt<INoteRepository>();
  List<Note> notes = [];
  List<Note> filteredNotes = [];
  final snackBar = SnackBar(
    content: Text('Deleted all notes successfully!'),
  );
  @override
  void initState() {
    super.initState();
    notes = noteRepository.getAll();
    filteredNotes = List<Note>.from(notes);

    setState(() {});
    noteRepository.getAllListen().listen((event) {
      notes = event;
      filteredNotes = List<Note>.from(notes);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  onSearchTextChanged(String text) async {
    print("NOTES LENGTH=${notes.length}");
    print("SEARCHTEXT: ${_searchTextController.text}");
    print("FILTEREDNOTES LENGTH ${filteredNotes.length}");
    setState(() {
      filteredNotes.forEach((element) {
        print("ID:${element.id}");
        print("NAME:${element.name}");
        print("DESCRIPTION:${element.description}");
      });
    });
    filteredNotes.clear();
    if (text.isEmpty || text == "") {
      setState(() {
        filteredNotes = new List<Note>.from(notes);
      });
      return;
    }

    notes.forEach((note) {
      if (note.name.toLowerCase().contains(text.toLowerCase()))
        filteredNotes.add(note);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 17, 23),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Are you sure?"),
                      content: const Text(
                          "Are you sure you want to delete ALL of these notes?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            noteRepository.deleteAll();
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
            icon: Icon(Icons.delete_outline_rounded),
          )
        ],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: TextField(
                    controller: _searchTextController,
                    onChanged: onSearchTextChanged,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "Search your notes!",
                        border: InputBorder.none),
                  ),
                ),
              ),
            )),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Notes",
            style: TextStyle(fontSize: 32),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        hoverColor: Colors.deepPurple,
        onPressed: () {
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: ((context) => CreateNotePage()),
              ),
              (route) => true);
        },
        backgroundColor: Colors.deepPurple[700],
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: filteredNotes.length,
        itemBuilder: (context, int index) =>
            ToDoTile(note: filteredNotes[index]),
      ),
      // body: Column(
      //   children: [
      //     const SizedBox(
      //       height: 10,
      //     ),
      //     //Search Bar

      //     const SizedBox(
      //       height: 10,
      //     ),
      //     Expanded(
      //       child: ListView.builder(
      //             padding: const EdgeInsets.all(8),
      //             itemCount: notes.length,
      //             itemBuilder: (context, int index) =>
      //                 To_Do_Tile(note: notes[index]),
      //           ),

      //       //Todo Lists
      //     )
      //   ],
      // ),
    );
  }
}
