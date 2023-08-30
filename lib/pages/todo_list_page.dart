import 'package:flutter/material.dart';
import 'package:todo_list/Widgets/taskStilying.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/models/tasks.dart';
import 'package:todo_list/repositories/todo_repositories.dart';

class ToDoList extends StatefulWidget {
  @override
  _ToDoListstate createState() => _ToDoListstate();
}

class _ToDoListstate extends State<ToDoList> {
  final TextEditingController taskController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Task> tasks = [];

  Task? deletedTask;
  int? deletedTaskPosition;

  @override
  void initState() {
    super.initState();
    todoRepository.getTodoList().then((value) {
      setState(() {
        tasks = value;
      });
    });
  }

  String? errorMessage;

  void addTask() {
    String text = taskController.text;

    if (text.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a task';
      });
      return;
    }


    setState(() {
      String timeNow = DateFormat('dd/MM/yyyy - HH:mm').format(DateTime.now());
      Task newTask = Task(task: text, date: timeNow);
      tasks.add(newTask);
      errorMessage= null;
    });
    taskController.clear();
    todoRepository.SaveTasks(tasks);
  }

  void alertDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text('Clear all?'),
        content: Text('Are you sure you want to clear all the tasks?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                tasks.clear();
                Navigator.of(context).pop();
              });
              todoRepository.SaveTasks(tasks);
            },
            child: Text(
              'Yes',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
              ),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Colors.red,
                ),
              ))
        ],
      ),
    );
  }

  void onDelete(Task task) {
    deletedTask = (task);
    deletedTaskPosition = tasks.indexOf(task);
    setState(() {
      tasks.remove(task);
    });
    todoRepository.SaveTasks(tasks);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Container(
        padding: EdgeInsets.all(
          10,
        ),
        child: Text(
          'The task ${task.task} was successfully removed',
          style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w400),
        ),
      ),
      backgroundColor: Colors.white,
      action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              tasks.insert(deletedTaskPosition!, deletedTask!);
            });
          }),
    ));
  }

  bool get isTaskLength => tasks.isNotEmpty;

  bool get isTaskOne => tasks.length == 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.white,
          child: (Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 40, bottom: 10, left: 25, right: 25),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      ' To do list',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                          fontSize: 34,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20, width: 350),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          controller: taskController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.3),
                            hintText: 'Add a task',
                            errorText: errorMessage,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(color: Colors.black45)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6.5),
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent),
                        onPressed: addTask,
                        child: const Text('+',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 35)),
                      ),
                    ],
                  ),
                  SizedBox(height: 3),
                  Flexible(
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      addAutomaticKeepAlives: true,
                      children: [
                        for (Task task in tasks)
                          taskStiling(
                            task: task,
                            onDelete: onDelete,
                          ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        isTaskOne
                            ? 'You have 1 task to do'
                            : 'You have ${tasks.length} tasks to do',
                        style: TextStyle(color: Colors.black.withOpacity(0.8)),
                      ),
                      SizedBox(width: 65),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent),
                        onPressed: isTaskLength ? alertDialog : null,
                        child: (Text(
                          'Clear all',
                          style: TextStyle(color: Colors.white),
                        )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
