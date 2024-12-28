import 'package:flutter/material.dart';
import 'package:todolist/util/dialog_box.dart';
import 'package:todolist/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //Recupère les informations de AlertDialog
  final _controller = TextEditingController();

  //Liste des ToDoList
  List toDoList = [
    ["Make Tutorial", false],
    ["Do Exercise", false]
  ];

  //Fonction pour gérer le changement du checkbox
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
  }

  //Fonction pour ajouter de sauvegarde
  void saveNewTask(){
    setState(() {
      toDoList.add([ _controller.text, false]);
      //Supprime le contenu du controller lorsqu'on ajoute une tâche
      _controller.clear();
    });
    Navigator.of(context).pop();
  }

  //Fonction pour que un utilisateur puise ajouter une tâche
  void createNewTask(){
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  //Fonction qui supprime une tâche
  void deleteTask(int index){
    setState(() {
      toDoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Center(child: Text("TO DO"),),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: toDoList.length,
        itemBuilder: (context, index) {
          //ToDoTile gère la logique des tâches
          return ToDoTile(
            taskName: toDoList[index][0],
            taskCompleted: toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
