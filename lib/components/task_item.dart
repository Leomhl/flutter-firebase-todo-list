import 'package:flutter/material.dart';
import 'package:todolist/models/task.dart';
import 'package:firebase_database/firebase_database.dart';

class TaskItem extends StatefulWidget {
  Task task;
  TaskItem(this.task);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {

  final databaseReference = FirebaseDatabase(
      databaseURL: 'https://todo-list-a8b3c-default-rtdb.firebaseio.com/'
  ).reference();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          IconButton(icon:
            Icon(
              widget.task.icon,
              color: widget.task.iconColor,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                print("Date ${widget.task.date}");
                print("Titulo: ${widget.task.title}");

                  databaseReference.child(widget.task.date)
                  .child(widget.task.title).update({
                    'done': !widget.task.done,
                  });

                  widget.task.done = !widget.task.done;
              });
            },
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.task.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(widget.task.description,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.normal
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
