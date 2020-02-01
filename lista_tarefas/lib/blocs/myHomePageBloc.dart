

import 'package:flutter/cupertino.dart';
import 'package:lista_tarefas/storageHelper.dart';
import 'package:lista_tarefas/task.dart';

class MyHomePageBloc {
  MyHomePageBloc({@required this.storageHelper});

  final StorageHelper storageHelper;
  int _lastRemovedPos;
  Task lastRemovedTask;

  //This is the last loaded toDoList.
  List<Task> toDoList;
  Future<List<Task>> _toDoListFuture;
  Future<List<Task>> get toDoListFuture => _toDoListFuture ??= _loadData();

  Future<List<Task>> _loadData() async {
    final data = await storageHelper.readData<List>();
    toDoList = [];
    toDoList = data?.map((model) {
      var map = model as Map<String,dynamic>;
      if(map != null)
        return Task.fromJson(map);
      return null;
    })?.toList() ?? [];


    toDoList.sort((Task a, Task b) {
      if(a.isOK && !b.isOK) return 1;
      else if(!a.isOK && b.isOK) return -1;
      return 0;
    });

    return toDoList;
  }

  void reloadData() => _toDoListFuture = null;

  void removeTaskAt(int index){
    _lastRemovedPos = index;
    lastRemovedTask = toDoList[index];
    toDoList.removeAt(index);
  }

  void restoreLastRemovedTask(){
    toDoList.insert(_lastRemovedPos, lastRemovedTask);
    clearRemovedTaskReferences();
  }

  String newTaskValidator(String value) {
    if (value == null || value.isEmpty) return "A tarefa precisa de um nome.";
    return null;
  }

  void addTask(String taskTitle) {
    toDoList.insert(0, Task(taskTitle,false));
    _saveData();
  }

  void updateTaskStatus(bool isFinished, int taskIndex) {
    toDoList[taskIndex].isOK = isFinished;
    _saveData();
  }

  void _saveData(){
    storageHelper.saveList(toDoList);
  }

  void clearRemovedTaskReferences(){
    lastRemovedTask = null;
    _lastRemovedPos = null;
  }

}