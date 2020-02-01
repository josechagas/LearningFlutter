import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:lista_tarefas/task.dart';
import 'package:path_provider/path_provider.dart';


class StorageHelper{
  StorageHelper(this.fileName);
  String fileName;

  Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/$fileName");
  }

  Future<File> _saveData(String data) async {
    final file = await getFile();
    return file.writeAsString(data);
  }

  Future<File> saveList(List list) async {
    try{
      String data = json.encode(list);
      print(data);
      return _saveData(data);
    }
    catch(e){
      print(e);
      return null;
    }
  }

  Future<T> readData<T>() async {
    try{
      final file = await getFile();
      final data = await file.readAsString();
      var list = json.decode(data);
      //List<Task> list2 = json.decode(data);
      return list;
    }
    catch(e){
      print(e);
      return null;
    }
  }

}