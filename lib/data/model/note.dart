import 'package:json_annotation/json_annotation.dart';
import 'package:todo_list/data/model/task.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  int id;
  String name;
  String? description;
  List<Task>? tasks;

  Note({
    required this.id,
    required this.name,
    this.description,
    this.tasks,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return _$NoteFromJson(json);
  }

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
