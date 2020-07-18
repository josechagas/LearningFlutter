import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_favorites/ui/load_info_widget.dart';

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //this method is designed to show results of search method.
    Future.delayed(Duration(seconds: 0)).then((value) => close(context, query));
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty) {
      return Container();
    }
    else {
      return FutureBuilder<List<String>>(
        future: suggestions(query),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.waiting) {
            return LinearProgressIndicator();
          }
          if(snapshot.hasData){
            return ListView.builder(itemBuilder: (context, index){
              final item = snapshot.data[index];
              return _buildSuggestionItem(context, item);
            }, itemCount: snapshot.data.length,);
          }
          if(snapshot.hasError){
            print(snapshot.error);
          }
          return Container();
        },
      );
    }
  }

  Widget _buildSuggestionItem(BuildContext context, String item){
    return ListTile(
      title: Text(
        item,
      ),
      trailing: Icon(
        Icons.chevron_right,
      ),
      onTap: (){
        close(context, item);
      },
    );
  }

  Future<List<String>> suggestions(String search) async {
    http.Response response = await http.get(
      'http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json',
    );
    if(response.statusCode == 200) {
      return (json.decode(response.body)[1] as List).map((v){
        return v[0] as String;
      }).toList();
    }
    else {
      throw Exception('failed to load suggestions');
    }
  }
}
