// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'todo_bloc.dart';
import 'database.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TodoDatabase database = TodoDatabase.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Bloc Todo App',
      home: BlocProvider(
        create: (context) => TodoBloc(database)..add(LoadTodos()),
        child: HomePage(),
      ),
    );
  }
}
