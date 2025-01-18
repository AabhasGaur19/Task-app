import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();

class Todo {
  Todo({
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.date,
    String? id,
  }) : id = id ?? uuid.v4();

  String id;
  String title;
  String description;
  DateTime date;
  bool isCompleted;

  String get formattedDate {
    return DateFormat.yMMMMd('en_IN').format(date);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      isCompleted: json['isCompleted'],
    );
  }
}
