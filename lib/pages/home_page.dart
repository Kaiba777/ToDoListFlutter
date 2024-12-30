import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/data/database.dart';
import 'package:todolist/util/dialog_box.dart';
import 'package:todolist/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //gère la base de données en local
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {

    //Créer des données par défaut si c'est la première fois on ouvre l'app
    if (_myBox.get("TODOLIST")  == null) {
      db.createInitialData();
    } else {
      //sinon charger les données de la base de données
      db.loadData();
    }

    super.initState();
  }

  //Recupère les informations de AlertDialog
  final _controller = TextEditingController();

  //Fonction pour gérer le changement du checkbox
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    //Mise à jour de la base de données après que l'utilisateur à cocher une tâche
    db.updateDataBase();
  }

  //Fonction pour ajouter de sauvegarde
  void saveNewTask(){
    setState(() {
      db.toDoList.add([ _controller.text, false]);
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
      db.toDoList.removeAt(index);
    });
    //Supprimer la tâche cocher
    db.updateDataBase();
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
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          //ToDoTile gère la logique des tâches
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
