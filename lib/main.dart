import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:todo_list/pages/todo_list_page.dart';
import 'package:todo_list/Widgets/taskStilying.dart';

void main() {
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ToDoList(),
    );
  }
}

