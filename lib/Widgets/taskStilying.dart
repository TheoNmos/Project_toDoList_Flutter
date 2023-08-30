import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/models/tasks.dart';


class taskStiling extends StatelessWidget {
  const taskStiling({Key? key, required this.task, required this.onDelete}) : super(key: key);

  final Task task;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Slidable(
        actionPane:  SlidableStrechActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: [
          IconSlideAction(
            caption: 'Delete',
            icon: Icons.delete,
            color: Colors.red,
            onTap: (){
              onDelete(task);
            },
          )
        ],
        child: Column(
            children: [

                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey[100]),
                  padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          task.date,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            task.task,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          )),
                    ],
                  ),
                ),
            ],
        ),
      ),
    );
  }
}
