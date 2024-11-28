import 'package:flutter/material.dart';
import 'package:todoapp/constants/colors.dart';
import 'package:todoapp/widgets/todo_items.dart';
import '../mode/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding and decoding


void main() {
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  List<ToDo> todoList = ToDo.todoList();

  final _todoController = TextEditingController();


  @override
  void initState() {
    super.initState();
    loadToDoList();
  }




  void saveToDoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todoListString = todoList.map((todo) => json.encode(todo.toJson())).toList();
    prefs.setStringList('todoList', todoListString);
  }

  void loadToDoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? todoListString = prefs.getStringList('todoList');
    if (todoListString != null) {
      todoList = todoListString.map((item) => ToDo.fromJson(json.decode(item))).toList();
      setState(() {});
    }
  }

  void handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
    saveToDoList();
  }

  void deleteToDoItem(ToDo todo) {
    setState(() {
      todoList.remove(todo);
    });
    saveToDoList();
  }

  void _addToDoItem(String todo) {
    setState(() {
      todoList.add(ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoText: todo));
    });
    _todoController.clear();
    saveToDoList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: tdBGColor,
          title: Row(
            children: [
              Icon(
                Icons.menu,
                color: tdblack,
                size: 30,
              ),
              SizedBox(
                width: 80,
              ),
              Text(
                "TO DO APP",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: tdblack,
                ),
              ),
              SizedBox(
                width: 60,
              ),
              Container(
                height: 40,
                width: 40,
                child: ClipRRect(
                  child: Image.asset(
                    "assets/images/office-man.png",
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, top: 20, bottom: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                          prefixIcon: Icon(
                            Icons.search,
                            color: tdblack,
                            size: 20,
                          ),
                          hintText: "Search",
                          hintStyle: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  
                  child: ListView(
                    
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                          child: Column(
                            children: [
                              for (var todo in todoList)
                                TodoItems(
                                  todo: todo,
                                  onToDoChanged: handleToDoChange,
                                  onDelete: deleteToDoItem,
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: 20,
                        right: 20,
                        left: 20,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 10.0,
                            spreadRadius: 0,
                          )
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _todoController,
                        decoration: InputDecoration(
                            hintText: "Add a new to do Item",
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        _addToDoItem(_todoController.text);
                      },
                      child: Text("+"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tdBlue,
                        foregroundColor: Colors.white,
                        minimumSize: Size(60, 60),
                        elevation: 10,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

 