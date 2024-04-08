import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';
import '../util/dialog_box.dart';
import '../util/todo_tile.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final toDoDatabase = Provider.of<ToDoDatabase>(context);
    final _myBox = Hive.box('mybox');

    final _controller = TextEditingController();
    final _descriptionController =
        TextEditingController(); // New controller for description

    void checkBoxChanged(bool? value, int index) {
      final newList = List.from(toDoDatabase.toDoList);
      newList[index][2] = value ?? false; // Ensure the correct index is updated
      toDoDatabase.updateDatabase(newList);
    }

    void saveNewTask() {
      final taskName = _controller.text.trim();
      final description = _descriptionController.text.trim();
      if (taskName.isNotEmpty) {
        final newList = List.from(toDoDatabase.toDoList);
        newList.add([taskName, description, false]);
        _controller.clear();
        _descriptionController.clear();
        Navigator.of(context).pop();
        toDoDatabase.updateDatabase(newList);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task name cannot be empty.'),
          ),
        );
      }
    }

    void createNewTask() {
      showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            descriptionController:
                _descriptionController, // Pass description controller
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        },
      );
    }

    void deleteTask(int index) {
      final newList = List.from(toDoDatabase.toDoList);
      newList.removeAt(index);
      toDoDatabase.updateDatabase(newList);
    }

    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Text('To Do'),
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: Consumer<ToDoDatabase>(
        builder: (context, database, child) {
          final toDoList = database.toDoList;
          return ListView.builder(
            itemCount: toDoList.length,
            itemBuilder: (context, index) {
              return ToDoTile(
                taskName: toDoList[index][0],
                description: toDoList[index][1], // Pass description
                taskCompleted: toDoList[index]
                    [2], // Index 2 for task completion
                onChanged: (value) => checkBoxChanged(value, index),
                deleteFunction: (context) => deleteTask(index),
              );
            },
          );
        },
      ),
    );
  }
}
