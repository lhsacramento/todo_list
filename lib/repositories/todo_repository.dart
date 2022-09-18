import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/todo.dart';

class TodoRepository{
  TodoRepository(){
    SharedPreferences.getInstance().then((value) => sharedPreferences = value);
  }

  late SharedPreferences sharedPreferences;
  String listKey = 'todo_List';

  void saveTodoList(List<Todo> todos){
    String todoListJson = json.encode(todos);
    sharedPreferences.setString(listKey, todoListJson);
  }

  Future<List<Todo>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String jsonSavedTodoList = sharedPreferences.getString(listKey) ?? '';

    List savedTodoList = json.decode(jsonSavedTodoList);
    return savedTodoList.map((e) => Todo.fromJson(e)).toList();
  }
}