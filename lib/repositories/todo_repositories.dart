import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/tasks.dart';

  const todoListKey = 'todo_list';
class TodoRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Task>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Task.fromJson(e)).toList();
  }

  void SaveTasks(List<Task> tasks) {
    final String jsonString = json.encode(tasks);
    sharedPreferences.setString(todoListKey, jsonString);
  }
}