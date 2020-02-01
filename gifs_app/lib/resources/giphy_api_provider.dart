import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gifs_app/models/item_model.dart';
import 'package:http/http.dart' as http;

class GiphyApiProvider {
  final _apiKey = "mubpJK4MBTVvfcmBp9mUMafCmJwAzfjr";

  Future<GiphyApiResponse> loadTrending({int pageLimit = 20}) async {
    final url = "https://api.giphy.com/v1/gifs/trending?"
        "api_key=$_apiKey&limit=$pageLimit&rating=G";
    final response = await http.get(url);
    return _giphyResponseFromJson(response);
  }

  Future<GiphyApiResponse> searchBy(
      {@required String search, int page = 0}) async {
    final pageLimit = 25;
    final url = "https://api.giphy.com/v1/gifs/search?"
        "api_key=$_apiKey&q=$search&limit=$pageLimit&offset=${pageLimit * page}&rating=G&lang=en";
    final response = await http.get(url);
    return _giphyResponseFromJson(response);
  }

  GiphyApiResponse _giphyResponseFromJson(http.Response response) {
    GiphyApiResponse data;
    try {
      Map<String, dynamic> map = json.decode(response.body);
      data = GiphyApiResponse.fromJson(map);
    } catch (e) {
      print(e);
    }
    return data;
  }
}

/*
class ApiResponse<T> extends http.Response {
  ApiResponse(String body, int statusCode,
      {http.BaseRequest request,
        Map<String, String> headers = const {},
        bool isRedirect = false,
        bool persistentConnection = true,
        String reasonPhrase}):super(
    body,
    statusCode,
    request: request,
    headers: headers,
    isRedirect: isRedirect,
    persistentConnection: persistentConnection,
    reasonPhrase: reasonPhrase,
  );

  T get decodedBody => json.decode(body);
}
*/

/**
 *
 * {
 *  "data":[
 *
 *             {
    "type": "gif",
    "id": "9DlIfRNMO79kbLyV8w",
    "url": "https://giphy.com/gifs/schittscreek-schitts-creek-poptv-9DlIfRNMO79kbLyV8w",
    "slug": "schittscreek-schitts-creek-poptv-9DlIfRNMO79kbLyV8w",
    "bitly_gif_url": "https://gph.is/g/aKKzADa",
    "bitly_url": "https://gph.is/g/aKKzADa",
    "embed_url": "https://giphy.com/embed/9DlIfRNMO79kbLyV8w",
    "username": "schittscreek",
    "source": "poptv.com/schittscreek",
    "title": "pop tv jenniferrobertson GIF by Schitt's Creek",
    "rating": "g",
    "content_url": "",
    "source_tld": "",
    "source_post_url": "poptv.com/schittscreek",
    "is_sticker": 0,
    "import_datetime": "2019-03-07 03:55:39",
    "trending_datetime": "2019-12-15 02:52:19",
    "images":
    {
    "downsized_large":
    {
    "height": "480",
    "size": "3414798",
    "url": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/giphy.gif?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=giphy.gif",
    "width": "480"
    },
    "fixed_height_small_still":
    {
    "height": "100",
    "size": "5723",
    "url": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/100_s.gif?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=100_s.gif",
    "width": "100"
    },
    "original":
    {
    "frames": "33",
    "hash": "177c048548a69689bb4aec318f18f4e6",
    "height": "480",
    "mp4": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/giphy.mp4?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=giphy.mp4",
    "mp4_size": "241222",
    "size": "3414798",
    "url": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/giphy.gif?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=giphy.gif",
    "webp": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/giphy.webp?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=giphy.webp",
    "webp_size": "291576",
    "width": "480"
    },
    "fixed_height_downsampled":
    {
    "height": "200",
    "size": "117634",
    "url": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/200_d.gif?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=200_d.gif",
    "webp": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/200_d.webp?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=200_d.webp",
    "webp_size": "53630",
    "width": "200"
    },
    "downsized_still":
    {
    "height": "480",
    "size": "54744",
    "url": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/giphy-downsized_s.gif?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=giphy-downsized_s.gif",
    "width": "480"
    },
    "fixed_height_still":
    {
    "height": "200",
    "size": "15282",
    "url": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/200_s.gif?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=200_s.gif",
    "width": "200"
    },
    "downsized_medium":
    {
    "height": "480",
    "size": "1926942",
    "url": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/giphy-downsized-medium.gif?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=giphy-downsized-medium.gif",
    "width": "480"
    },
    "downsized":
    {
    "height": "480",
    "size": "1661315",
    "url": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/giphy-downsized.gif?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=giphy-downsized.gif",
    "width": "480"
    },
    "preview_webp":
    {
    "height": "182",
    "size": "42446",
    "url": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/giphy-preview.webp?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=giphy-preview.webp",
    "width": "182"
    },
    "original_mp4":
    {
    "height": "480",
    "mp4": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/giphy.mp4?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=giphy.mp4",
    "mp4_size": "241222",
    "width": "480"
    },
    "fixed_height_small":
    {
    "height": "100",
    "mp4": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/100.mp4?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=100.mp4",
    "mp4_size": "16576",
    "size": "162852",
    "url": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/100.gif?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=100.gif",
    "webp": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/100.webp?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=100.webp",
    "webp_size": "43486",
    "width": "100"
    },
    "fixed_height":
    {
    "height": "200",
    "mp4": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/200.mp4?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=200.mp4",
    "mp4_size": "43845",
    "size": "475027",
    "url": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/200.gif?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=200.gif",
    "webp": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/200.webp?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=200.webp",
    "webp_size": "132288",
    "width": "200"
    },
    "downsized_small":
    {
    "height": "364",
    "mp4": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/giphy-downsized-small.mp4?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=giphy-downsized-small.mp4",
    "mp4_size": "51299",
    "width": "364"
    },
    "preview":
    {
    "height": "192",
    "mp4": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/giphy-preview.mp4?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=giphy-preview.mp4",
    "mp4_size": "17083",
    "width": "192"
    },
    "fixed_width_downsampled":
    {
    "height": "200",
    "size": "117634",
    "url": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/200w_d.gif?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=200w_d.gif",
    "webp": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/200w_d.webp?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=200w_d.webp",
    "webp_size": "53630",
    "width": "200"
    },
    "fixed_width_small_still":
    {
    "height": "100",
    "size": "5723",
    "url": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/100w_s.gif?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=100w_s.gif",
    "width": "100"
    },
    "fixed_width_small":
    {
    "height": "100",
    "mp4": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/100w.mp4?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=100w.mp4",
    "mp4_size": "16576",
    "size": "162852",
    "url": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/100w.gif?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=100w.gif",
    "webp": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/100w.webp?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=100w.webp",
    "webp_size": "43486",
    "width": "100"
    },
    "original_still":
    {
    "height": "480",
    "size": "170535",
    "url": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/giphy_s.gif?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=giphy_s.gif",
    "width": "480"
    },
    "fixed_width_still":
    {
    "height": "200",
    "size": "15282",
    "url": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/200w_s.gif?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=200w_s.gif",
    "width": "200"
    },
    "looping":
    {
    "mp4": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/giphy-loop.mp4?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=giphy-loop.mp4",
    "mp4_size": "3920291"
    },
    "fixed_width":
    {
    "height": "200",
    "mp4": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/200w.mp4?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=200w.mp4",
    "mp4_size": "43845",
    "size": "475027",
    "url": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/200w.gif?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=200w.gif",
    "webp": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/200w.webp?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=200w.webp",
    "webp_size": "132288",
    "width": "200"
    },
    "preview_gif":
    {
    "height": "108",
    "size": "48352",
    "url": "https://media0.giphy.com/media/9DlIfRNMO79kbLyV8w/giphy-preview.gif?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=giphy-preview.gif",
    "width": "108"
    },
    "480w_still":
    {
    "url": "https://media1.giphy.com/media/9DlIfRNMO79kbLyV8w/480w_s.jpg?cid=217c2c0d2470f9eb4cf414535f0ba61f4c2140baa50d85dc&rid=480w_s.jpg",
    "width": "480",
    "height": "480"
    }
    },
    "user":
    {
    "avatar_url": "https://media4.giphy.com/channel_assets/schitts-creek/CpjFxteIg3e2.jpg",
    "banner_image": "",
    "banner_url": "",
    "profile_url": "https://giphy.com/schittscreek/",
    "username": "schittscreek",
    "display_name": "Schitt's Creek",
    "is_verified": true
    },
    "analytics":
    {
    "onload":
    {
    "url": "https://giphy-analytics.giphy.com/simple_analytics?response_id=2470f9eb4cf414535f0ba61f4c2140baa50d85dc&event_type=GIF_TRENDING&gif_id=9DlIfRNMO79kbLyV8w&action_type=SEEN"
    },
    "onclick":
    {
    "url": "https://giphy-analytics.giphy.com/simple_analytics?response_id=2470f9eb4cf414535f0ba61f4c2140baa50d85dc&event_type=GIF_TRENDING&gif_id=9DlIfRNMO79kbLyV8w&action_type=CLICK"
    },
    "onsent":
    {
    "url": "https://giphy-analytics.giphy.com/simple_analytics?response_id=2470f9eb4cf414535f0ba61f4c2140baa50d85dc&event_type=GIF_TRENDING&gif_id=9DlIfRNMO79kbLyV8w&action_type=SENT"
    }
    }
    },
 *
 *  ]
 * }
 *
 *
 * */
