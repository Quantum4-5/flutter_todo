import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todoapp/constants/colors.dart';
import 'package:todoapp/mode/todo.dart';

class TodoItems extends StatefulWidget {
  final ToDo todo;
  
  final Function(ToDo) onToDoChanged;
  final void Function(ToDo) onDelete;

  const TodoItems({
    Key? key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<TodoItems> createState() => _TodoItemsState();
}

class _TodoItemsState extends State<TodoItems> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          setState(() {
            widget.todo.isDone = !widget.todo.isDone;
          });
         
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        tileColor: Colors.white,
        leading: Icon(
          widget.todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: tdBlue,
        ),
        title: Text(
          widget.todo.todoText!,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Oswald',
            decoration: widget.todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: tdRed,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            onPressed: () {
              widget.onDelete(widget.todo);
            },
            icon: Icon(Icons.delete),
          ),
        ),
      ),
    );
  }
}
