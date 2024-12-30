import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase{
  //Stocke les tâches
  List toDoList = [];
  final _myBox = Hive.box("mybox");

  //Initialisation de la base de données
  void createInitialData(){
    toDoList = [
      ["Make Tutorial", false],
      ["Do Exercise", false],
    ];
  }

  //Récupère les données de la base de données
  void loadData(){
    toDoList = _myBox.get("TODOLIST");
  }

  // Mise à jour de la base de données: car si je coche
  // une tâche cela signifie que j'ai accomplie une tâche
  void updateDataBase(){
    _myBox.put("TODOLIST", toDoList);
  }
}