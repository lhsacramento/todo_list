import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';

class TodoListItem extends StatelessWidget {
  TodoListItem({Key? key, required this.todo, required this.deleteItem, required this.editItem}) : super(key: key);

  final Todo todo;
  IconData tudoIcon = Icons.book;
  final Function(Todo) deleteItem;
  final Function(Todo) editItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.55,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              backgroundColor: const Color(0xff00d7f3),
              icon: Icons.edit,
              label: 'Editar',
              onPressed: (context){
                editItem(todo);
              },
            ),
            SlidableAction(
              backgroundColor: Colors.red,
              icon: Icons.delete,
              label: 'Deletar',
              onPressed: (context){
                deleteItem(todo);
              },
            ),
          ],
        ),
        child: Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: importTodoColor(todo.color),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      tudoIcon,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy - HH:mm').format(todo.dateTime),
                          style: const TextStyle(fontSize: 10),
                        ),
                        Text(
                          todo.title,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color importTodoColor(int color){
    Color? myColor;
    switch(color){
      case 0:
        myColor = Colors.red[300];
        break;
      case 1:
        myColor = Colors.yellow[300];
        break;
      case 2:
        myColor = Colors.green[300];
        break;
    }

    return myColor ?? Colors.green;
  }
}
