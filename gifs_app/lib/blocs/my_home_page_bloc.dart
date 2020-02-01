

import 'package:gifs_app/models/item_model.dart';
import 'package:gifs_app/resources/giphy_api_provider.dart';

class MyHomePageBloc {
  final gifsProvider = GiphyApiProvider();

  String search;
  int _searchPage = 0;//tutorial offset/pageCount

  Future currentFuture;
  GiphyApiResponse currentResponse;

  bool get isSearching => search != null && search.isNotEmpty;

  void loadMoreSearchResults(){
    currentFuture = _getGifs(
      newSearchPage: true,
    );
  }

  int getListCount() {
    final dataLength = currentResponse?.data?.length ?? 0;
    if(!isSearching){
      return dataLength;
    }
    return dataLength + 1;
  }

  void performSearch(String searchText){
    search = searchText;
    _searchPage = 0;
    currentResponse = null;
    currentFuture = _getGifs();
  }

  void loadGifs(){
    currentFuture = _getGifs();
  }

  Future<GiphyApiResponse> _getGifs({bool newSearchPage = false}) async {
    GiphyApiResponse response;
    if(!isSearching){
      response = await gifsProvider.loadTrending();
      currentResponse = response;
    }
    else{
      if(newSearchPage)
        _searchPage += 1;
      response = await gifsProvider.searchBy(
          search: search,
          page: _searchPage);

      if(newSearchPage)
        currentResponse.data.addAll(response.data);
      else
        currentResponse = response;
    }

    return response;
  }
}