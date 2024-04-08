import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ToDoDatabase extends ChangeNotifier {
  final Box _myBox;

  ToDoDatabase(this._myBox);

  List get toDoList => _myBox.get("TODOLIST", defaultValue: []);

  void createInitialData() {
    final initialData = [
      ["Make Tutorial", false],
      ["Do Exercise", false],
    ];
    _myBox.put("TODOLIST", initialData);
    notifyListeners();
  }

  void updateDatabase(List updatedList) {
    _myBox.put("TODOLIST", updatedList);
    notifyListeners();
  }
}
