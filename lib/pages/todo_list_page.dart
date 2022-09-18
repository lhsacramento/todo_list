import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/repositories/todo_repository.dart';
import 'package:todo_list/widgets/todo_list_item.dart';

import '../models/todo.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();

  List<Todo> todos = [];
  TodoRepository todoRepository = TodoRepository();

  String? errorText;

  List<bool> changeSelectColorButton = [false,false,true];
  int buttonColorController = 2;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
        print(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Lista de Tarefas',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xff00d7f3),
                          padding: const EdgeInsets.all(14),
                        ),
                        onPressed: () {
                              showCreateNewTodo();
                        },
                        child: const Text('Adicionar Tarefa'))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in sortList(todos))
                        TodoListItem(
                          todo: todo,
                          deleteItem: deleteTodo,
                          editItem: editItem,
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Você possui ${todos.length} tarefas pendentes',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xff00d7f3),
                        padding: const EdgeInsets.all(14),
                      ),
                      onPressed: () {
                        deleteAllConfirmation();
                        sortList(todos);
                      },
                      child: const Text(
                        'Limpar Tudo',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showCreateNewTodo() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Adicionar nova tarefa'),
                content: SizedBox(
                  height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Nome da Tarefa',
                          hintText: 'Ex. Estudar Flutter',
                          errorText: errorText,
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff00d7f3),
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text('Escolha a prioridade:'),
                      Row(
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor: changeSelectColorButton[0] ? MaterialStateProperty.all(Colors.red[600])
                                  : MaterialStateProperty.all(Colors.red[200]),
                            ),
                            onPressed: () {
                              setState((){
                                changeButtonColor(0);
                              });
                            },
                            child: const Text(
                              '1',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            width: 19,
                          ),
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor:  changeSelectColorButton[1] ? MaterialStateProperty.all(Colors.yellow[600])
                                  : MaterialStateProperty.all(Colors.yellow[200]),
                            ),
                            onPressed: () {
                              setState((){
                                changeButtonColor(1);

                              });
                            },
                            child: const Text(
                              '2',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            width: 19,
                          ),
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor:  changeSelectColorButton[2] ? MaterialStateProperty.all(Colors.green[600])
                                  : MaterialStateProperty.all(Colors.green[200]),
                            ),
                            onPressed: () {
                              setState((){
                                changeButtonColor(2);
                              });
                            },
                            child: const Text(
                              '3',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        child: const Text('Adicionar Tarefa'),
                        onPressed: () async {
                          if (todoController.text.isEmpty) {
                            setState(() {
                              errorText = 'O título não pode estar vazio!';
                            });
                            return;
                          }

                          Todo newTodo = Todo(
                              title: todoController.text,
                              dateTime: DateTime.now(),
                              color: buttonColorController,
                            );
                            todos.add(newTodo);
                            errorText = null;
                            todoController.clear();
                            todoRepository.saveTodoList(todos);
                            Navigator.of(context).pop();
                            changeButtonColor(0);


                        }),
                        ],
                  ),
                ),
              );
            });
      } ,
    );
  }

  void deleteAllConfirmation() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Apagar todas as tarefas?'),
              content: const Text(
                  'Voce tem certeza que deseja apagar todas as tarefas?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Color(0xff00d7f3),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteAll();
                  },
                  child: const Text(
                    'Apagar Tudo',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            ));
  }

  void deleteAll() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }

  void editItem(Todo todo){
    todoController.text = todo.title;
    changeButtonColor(todo.color);
    int oldTudoPosition = todos.indexOf(todo);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Editar tarefa'),
                content: SizedBox(
                  height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Nome da Tarefa',
                          hintText: 'Ex. Estudar Flutter',
                          errorText: errorText,
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff00d7f3),
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text('Escolha a prioridade:'),
                      Row(
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor: changeSelectColorButton[0] ? MaterialStateProperty.all(Colors.red[600])
                                  : MaterialStateProperty.all(Colors.red[200]),
                            ),
                            onPressed: () {
                              setState((){
                                changeButtonColor(0);
                              });
                            },
                            child: const Text(
                              '1',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            width: 19,
                          ),
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor:  changeSelectColorButton[1] ? MaterialStateProperty.all(Colors.yellow[600])
                                  : MaterialStateProperty.all(Colors.yellow[200]),
                            ),
                            onPressed: () {
                              setState((){
                                changeButtonColor(1);

                              });
                            },
                            child: const Text(
                              '2',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            width: 19,
                          ),
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor:  changeSelectColorButton[2] ? MaterialStateProperty.all(Colors.green[600])
                                  : MaterialStateProperty.all(Colors.green[200]),
                            ),
                            onPressed: () {
                              setState((){
                                changeButtonColor(2);
                              });
                            },
                            child: const Text(
                              '3',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          child: const Text('Editar Tarefa'),
                          onPressed: () async {
                            if (todoController.text.isEmpty) {
                              setState(() {
                                errorText = 'O título não pode estar vazio!';
                              });
                              return;
                            }

                            Todo editedTodo = Todo(
                              title: todoController.text,
                              dateTime: DateTime.now(),
                              color: buttonColorController,
                            );
                            todos.insert(oldTudoPosition,editedTodo);
                            todos.remove(todo);
                            errorText = null;
                            todoController.clear();
                            todoRepository.saveTodoList(todos);
                            Navigator.of(context).pop();
                            changeButtonColor(0);
                          }),
                    ],
                  ),
                ),
              );
            });
      } ,
    );
  }

  void deleteTodo(Todo todo) {
    Todo excludedTodo = Todo(title: todo.title, dateTime: todo.dateTime, color: todo.color);
    int indexExcludedTodo = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${todo.title} excluída com sucesso',
          style: const TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
        ),
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: const Color(0xff00d7f3),
          onPressed: () {
            setState(() {
              todos.insert(indexExcludedTodo, excludedTodo);
            });
            todoRepository.saveTodoList(todos);
          },
        ),
      ),
    );
  }

  void changeButtonColor(int i){
    switch(i){
      case 0:
        changeSelectColorButton[0] = true;
        changeSelectColorButton[1] = false;
        changeSelectColorButton[2] = false;
        buttonColorController = 0;
        break;
      case 1:
        changeSelectColorButton[0] = false;
        changeSelectColorButton[1] = true;
        changeSelectColorButton[2] = false;
        buttonColorController = 1;
        break;
      case 2:
        changeSelectColorButton[0] = false;
        changeSelectColorButton[1] = false;
        changeSelectColorButton[2] = true;
        buttonColorController = 2;
        break;
    }

    setState((){
      print(todos.length);
    });
  }

  List<Todo> sortList(List<Todo> todos){
    List<Todo> firstPriority = [];
    List<Todo> secondPriority = [];
    List<Todo> thirdPriority = [];

    for(Todo todo in todos){
      switch(todo.color){
        case 0:
          firstPriority.add(todo);
          break;
        case 1:
          secondPriority.add(todo);
          break;
        case 2:
          thirdPriority.add(todo);
          break;
      }
    }
    List<Todo> sortedList = [...firstPriority,...secondPriority,...thirdPriority];
    return sortedList;
  }
}
