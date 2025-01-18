import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/model/todo.dart';
import 'package:todo/widgets/single_display.dart';

class DisplayTodo extends StatelessWidget {
  const DisplayTodo(this.todo, {required this.onToggleComplete, super.key});
  final Todo todo;
  final Function() onToggleComplete;

  String _getDateHeader() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final todoDate = DateTime(todo.date.year, todo.date.month, todo.date.day);

    if (todoDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
      return 'Today';
    } else if (todoDate.isAtSameMomentAs(tomorrow)) {
      return 'Tomorrow';
    } else {
      return '${todo.date.day}/${todo.date.month}/${todo.date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              _getDateHeader(),
              style: GoogleFonts.montserrat(
                fontSize: 18,
                color: Colors.white60,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleDisplay(todo, onToggleComplete),
            ),
          ),
        ],
      ),
    );
  }
}

