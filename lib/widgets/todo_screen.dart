import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/model/todo.dart';
import 'package:todo/widgets/diaplay_create_todo.dart';
import 'package:todo/widgets/display_todo.dart';
import 'package:todo/widgets/side_drawer.dart';
import 'package:todo/widgets/welcome_screen.dart';
import 'dart:convert';

class TodoScreen extends StatefulWidget {
  const TodoScreen(this.username, {super.key});
  final String username;

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  String? savedUsername;
  List<Todo> registeredTodo = [];

  @override
  void initState() {
    super.initState();
    getUsername();
    loadTodos();
  }

  Future<void> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedUsername = prefs.getString('username') ?? widget.username;
    });
  }

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? todoList = prefs.getStringList('todo_list');
    if (todoList != null) {
      setState(() {
        registeredTodo = todoList.map((todo) => Todo.fromJson(jsonDecode(todo))).toList();
      });
    }
  }

  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> todoList = registeredTodo.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList('todo_list', todoList);
  }

  void _addTodo(Todo newTodo) {
    setState(() {
      registeredTodo.add(newTodo);
    });
    saveTodos();
  }

  void _toggleTodoStatus(String id) {
    setState(() {
      final todoIndex = registeredTodo.indexWhere((todo) => todo.id == id);
      if (todoIndex != -1) {
        final oldTodo = registeredTodo[todoIndex];
        registeredTodo[todoIndex] = Todo(
          title: oldTodo.title,
          description: oldTodo.description,
          date: oldTodo.date,
          isCompleted: !oldTodo.isCompleted,
        );
        if (registeredTodo[todoIndex].isCompleted) {
          registeredTodo.removeAt(todoIndex);
        }
      }
    });
    saveTodos(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[200],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent[200],
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // something search would not work fine
            },
            icon: Icon(Icons.search),
            padding: EdgeInsets.only(right: 5),
          ),
        ],
      ),
      drawer: SideDrawer(savedUsername),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 14, left: 12, bottom: 16),
            child: Text(
              "What's up, $savedUsername!",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12, bottom: 16),
            child: Text(
              "Today's plans",
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: const Color.fromARGB(162, 255, 255, 255),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          registeredTodo.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: registeredTodo.length,
                    itemBuilder: (context, index) => DisplayTodo(
                      registeredTodo[index],
                      onToggleComplete: () => _toggleTodoStatus(registeredTodo[index].id),
                    ),
                  ),
                )
              : Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 230),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Add task',
                        style: GoogleFonts.montserrat(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTodo = await Navigator.push<Todo>(
            context,
            MaterialPageRoute(builder: (context) => CreateTodo()),
          );
          if (newTodo != null) {
            _addTodo(newTodo);
          }
        },
        elevation: 20,
        backgroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
