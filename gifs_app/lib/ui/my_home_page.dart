
import 'package:flutter/material.dart';
import 'package:gifs_app/blocs/my_home_page_bloc.dart';
import 'package:gifs_app/models/item_model.dart';
import 'package:gifs_app/ui/gif_page.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  final baseSpacing = 10.0;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final bloc = MyHomePageBloc();

  @override
  void initState() {
    super.initState();
    bloc.loadGifs();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = SizedBox(
      height: widget.baseSpacing,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: FadeInImage.memoryNetwork(
          fit: BoxFit.scaleDown,
            placeholder: kTransparentImage,
            image: "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
      ),
      body: Padding(
        padding: EdgeInsets.all(widget.baseSpacing),
        child: Column(
          children: <Widget>[
            spacing,
            _buildSearchTextField(),
            spacing,
            Expanded(
              child: FutureBuilder(
                future: bloc.currentFuture,
                initialData: bloc.currentResponse,
                builder: _buildBody,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTextField(){
    return TextField(
      decoration: InputDecoration(
        labelText: "Pesquise Aqui",
        labelStyle: TextStyle(
            color: Colors.white
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.search,
      style: Theme.of(context).textTheme.title.copyWith(
        color: Colors.white,
      ),
      onSubmitted: _onSearchTextFieldSubmitted,
    );
  }

  //Must be inside a FutureBuilder
  Widget _buildBody(BuildContext context, AsyncSnapshot snapshot){

    if(snapshot.hasError){
      return Center(
        child: Text(
            "ERROR",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
    else if(snapshot.hasData && !(bloc.currentResponse?.data?.isEmpty??true)){
      return _buildGifsGridView(context);
    }
    else {
      switch(snapshot.connectionState){
        case ConnectionState.waiting:
        case ConnectionState.active:
          return Center(
            child: CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 5.0,
            ),
          );
        default:
          break;
      }

      return Center(
        child: Text(
            "NO DATA",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }

  }


  Widget _buildGifsGridView(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: widget.baseSpacing,
          mainAxisSpacing: widget.baseSpacing
        ),
        itemCount: bloc.getListCount(),
        itemBuilder: _buildGridViewItem,
    );
  }

  Widget _buildGridViewItem(BuildContext context, int index) {
    final showGif = bloc.currentResponse.data.length > index;
    if(showGif) {
      final item = bloc.currentResponse.data[index];
      final gifImage = item.images.fixed_height;
      //InkWell creates Ripple effect, but because of FadeInImage this effect is behind thie widget
      return GestureDetector(
        child: Container(
          color: Colors.white12,
          child: FadeInImage.memoryNetwork(
            fadeInDuration: Duration(milliseconds: 300),
            height: gifImage.heightValue,
            placeholder: kTransparentImage,
            image: gifImage.url,
            fit: BoxFit.cover,
          ),
        ),
        onTap: ()=> onGifClick(item),
        onLongPress: () => shareItem(item),
      );
    }
    else if (bloc.isSearching){
      return _buildLoadMoreSearchResultsWidget();
    }
    return Container();
  }

  Widget _buildLoadMoreSearchResultsWidget(){
    return MaterialButton(
      height: 300.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.add,
            color: Colors.white,
            size: 70.0,
          ),
          Text(
            "Carregar mais...",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          )
        ],
      ),
      onPressed: _onLoadMoreSearchPressed,
    );
  }

  void onGifClick(ItemModel item) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => GifPage(item: item,)));
  }

  void shareItem(ItemModel item) {
    Share.share(item.images.fixed_height.url);
  }

  void _onLoadMoreSearchPressed(){
    setState(() {
      bloc.loadMoreSearchResults();
    });
  }

  void _onSearchTextFieldSubmitted(String searchText) {
    FocusScope.of(context).unfocus();
    setState(() {
      bloc.performSearch(searchText);
    });
  }


}
