import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lista_tarefas/blocs/myHomePageBloc.dart';
import 'package:lista_tarefas/storageHelper.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _newTaskTFController = TextEditingController();
  var _formKey = GlobalKey<FormFieldState>();

  final bloc = MyHomePageBloc(storageHelper: StorageHelper("data.json"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildCustomAppBar(),
        body: FutureBuilder(
          future: bloc.toDoListFuture,
          initialData: bloc.toDoList,
          builder: _buildFuture,
        ));
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot){
    if(snapshot.hasError){
      return _buildErrorWidget();
    }
    else if(snapshot.hasData){
      return RefreshIndicator(
        child: ListView.builder(
          itemCount: bloc.toDoList?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return _buildListViewItem(index);
          },
        ),
        onRefresh: _onRefreshIndicatorRefresh,
      );
    }
    else{
      switch(snapshot.connectionState) {
        case ConnectionState.active:
        case ConnectionState.waiting:
          return Center(
            child: CircularProgressIndicator(),
          );
        default:
          break;
      }
      return _buildNoDataWidget();
    }
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(168),
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("Teste"),
            brightness: Brightness.light,
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: _buildNewTaskWidget(),
              ),
              Divider(),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildNewTaskWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: TextFormField(
            key: _formKey,
            controller: _newTaskTFController,
            decoration: InputDecoration(labelText: "Nova Tarefa"),
            onChanged: (String value) {
              _formKey.currentState.validate();
            },
            validator: bloc.newTaskValidator,
            onSaved: _addTask,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Align(
          heightFactor: 1.78,
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: Text(
              "Salvar",
            ),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                _newTaskTFController.clear();
                FocusScope.of(context).unfocus();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListViewItem(int index) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        alignment: Alignment(-0.9, 0),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: _buildTaskItem(index),
      confirmDismiss: (_) {
        return confirmDeletion(index);
      },
      onDismissed: (_) {
        //called if confirmDismiss return true.
        _onDismissToDelete(index);
      },
    );
  }

  Widget _buildTaskItem(int index) {
    final task = bloc.toDoList[index];
    final itsOK = task.isOK;
    return CheckboxListTile(
      secondary: Icon(
        itsOK ? Icons.check_circle : Icons.error,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        task.title,
      ),
      value: itsOK,
      onChanged: (bool newValue) {
        _updateTaskStatus(newValue, index);
      },
    );
  }

  Widget _buildNoDataWidget(){
    return _buildInformationWidget("Nenhuma tarefa encontada!");
  }

  Widget _buildErrorWidget(){
    return _buildInformationWidget("Ocorreu um erro durante o carregamento das tarefas!");
  }

  Widget _buildInformationWidget(String title){
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.center,
          ),
          MaterialButton(
            child: Text(
                "Recarregar"
            ),
            onPressed: (){
              setState(() => bloc.reloadData());
            },
          )
        ],
      ),
    );
  }

  Future<void> _onRefreshIndicatorRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() => bloc.reloadData());
  }

  void _onDismissToDelete(int index) {
    setState(() => bloc.removeTaskAt(index));

    void cancelDelete() {
      setState(() => bloc.restoreLastRemovedTask());
    }

    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
              title: Text("Task deletada"),
              content:
                  Text("A task ${bloc.lastRemovedTask.title} foi deletada."),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("Cancelar"),
                  onPressed: () {
                    cancelDelete();
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    bloc.clearRemovedTaskReferences();
                  },
                ),
              ],
            );
          });
    } else {
      final snackBar = SnackBar(
        content: Text("A task ${bloc.lastRemovedTask.title} foi deletada"),
        action: SnackBarAction(
          label: "Cancelar",
          onPressed: () {
            cancelDelete();
          },
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<bool> confirmDeletion(int index) async {
    final task = bloc.toDoList[index];
    return showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text("Deletar Task"),
            content: Text("A task ${task.title} será deletada."),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              CupertinoDialogAction(
                child: Text("Continuar"),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        });
  }

  void _addTask(String taskTitle) {
    setState(() {
      bloc.addTask(taskTitle);
    });
  }

  void _updateTaskStatus(bool isFinished, int taskIndex) {
    setState(() {
      bloc.updateTaskStatus(isFinished, taskIndex);
    });
  }
}
