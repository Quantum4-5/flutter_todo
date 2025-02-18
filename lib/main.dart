import 'package:flutter/material.dart';
import 'package:todoapp/constants/colors.dart';
import 'package:todoapp/constants/themepages.dart';
import 'package:todoapp/theme_provider.dart';
import 'package:todoapp/widgets/todo_items.dart';
import '../mode/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding and decoding

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
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
    List<String> todoListString =
        todoList.map((todo) => json.encode(todo.toJson())).toList();
    prefs.setStringList('todoList', todoListString);
  }

  void loadToDoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? todoListString = prefs.getStringList('todoList');
    if (todoListString != null) {
      todoList =
          todoListString.map((item) => ToDo.fromJson(json.decode(item))).toList();
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
              SizedBox(width: 80),
              Text(
                "TO DO APP",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: tdBlue,
                ),
              ),
              Spacer(),
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage("assets/images/office-man.png"),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),

        drawer: Drawer(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 40),
                color: tdBlue,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage("assets/images/office-man.png"),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "John Doe",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "johndoe@example.com",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: tdBlue),
                title: Text("Home"),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.palette, color: tdBlue),
                title: Text("Appearance / Theme"),
                onTap: () {
                  Navigator.pop(context);
                   Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Themepages()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: tdBlue),
                title: Text("Settings"),
                onTap: () {
                  // Navigate to Settings Page
                },
              ),
              ListTile(
                leading: Icon(Icons.person, color: tdBlue),
                title: Text("Profile"),
                onTap: () {
                  // Navigate to Profile Page
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text("Sign Out", style: TextStyle(color: Colors.red)),
                onTap: () {
                  // Handle Sign Out
                },
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeProvider.backgroundColor
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                          prefixIcon: Icon(Icons.search, color: tdBlue, size: 20),
                          hintText: "Search",
                          hintStyle: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              for (var todo in todoList)
                                TodoItems(
                                  todo: todo,
                                  onToDoChanged: handleToDoChange,
                                  onDelete: deleteToDoItem,
                                ),
                            ],
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
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 10.0,
                          )
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _todoController,
                        decoration: InputDecoration(
                          hintText: "Add a new to do Item",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20, right: 20),
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
