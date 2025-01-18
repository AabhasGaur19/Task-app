import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/todo.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({super.key});

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _descController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _datePicker() async {
    final now = DateTime.now();
    final firstDate = now;
    final lastDate = DateTime(now.year + 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Future<void> _saveTodo(Todo todo) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> todoList = prefs.getStringList('todo_list') ?? [];
    
    todoList.add(jsonEncode(todo.toJson()));
    await prefs.setStringList('todo_list', todoList);
  }

  void _submitTodo() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a title')),
      );
      return;
    }
    if (_descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a description')),
      );
      return;
    }

    final todo = Todo(
      description: _descController.text,
      title: _titleController.text,
      date: _selectedDate ?? DateTime.now(),
      isCompleted: false,
    );

    await _saveTodo(todo);
    Navigator.pop(context, todo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent[200],
        title: Text(
          'Add a new task',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 17, vertical: 17),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8, top: 10),
                child: Text(
                  'Task title',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                ),
              ),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  label: Text('Title'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8, top: 15),
                child: Text(
                  'Task description',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                ),
              ),
              TextField(
                controller: _descController,
                decoration: InputDecoration(
                  hintText: 'Description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                ),
                maxLines: null,
                minLines: 3,
                keyboardType: TextInputType.multiline,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 15),
                child: Text(
                  'Due Date',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'No date selected'
                          : DateFormat.yMMMMd('en_IN').format(_selectedDate!),
                      style: TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      onPressed: _datePicker,
                      icon: Icon(Icons.calendar_month, color: Colors.blueAccent[200]),
                    ),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 17),
                  child: ElevatedButton(
                    onPressed: _submitTodo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent[200],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      minimumSize: Size(400, 50),
                    ),
                    child: Text('Create new task'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
