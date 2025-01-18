import 'package:flutter/material.dart';
import 'package:todo/widgets/welcome_screen.dart';
import 'package:todo/widgets/todo_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('en_IN', null);

  final prefs = await SharedPreferences.getInstance();
  final String? username = prefs.getString('username'); 

  runApp(MyApp(initialScreen: username != null ? TodoScreen(username) : WelcomeScreen()));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blueAccent[200],
      ),
      home: initialScreen, 
    );
  }
}
