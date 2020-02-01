
import 'package:json_annotation/json_annotation.dart';

part 'item_model.g.dart';

@JsonSerializable()
class ItemModel {
  String type;
  String id;
  String url;
  String slug;
  String bitlyGifUrl;
  String bitlyUrl;
  String embedUrl;
  String username;
  String source;
  String title;
  String rating;
  String contentUrl;
  String sourceTld;
  String sourcePostUrl;
  bool isSticker;
  DateTime importDatetime;
  DateTime trendingDatetime;
  Images images;

  //User user;
  //Analytics analytics;

  ItemModel(
      {this.type,
      this.id,
      this.url,
      this.slug,
      this.bitlyGifUrl,
      this.bitlyUrl,
      this.embedUrl,
      this.username,
      this.source,
      this.title,
      this.rating,
      this.contentUrl,
      this.sourceTld,
      this.sourcePostUrl,
      this.isSticker,
      this.importDatetime,
      this.trendingDatetime,
      this.images});

  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$ItemModelToJson(this);


  static buildItemModelList(List<Map<String, dynamic>> jsonList) {
    return jsonList?.map((Map item){
      return ItemModel.fromJson(item);
    });
  }
}

@JsonSerializable()
class GiphyApiResponse {
  List<ItemModel> data;

  GiphyApiResponse({this.data});

  factory GiphyApiResponse.fromJson(Map<String, dynamic> json) =>
      _$GiphyApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GiphyApiResponseToJson(this);
}

@JsonSerializable()
class Images {
  ImageFixedHeight fixed_height;

  Images({this.fixed_height});

  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);
  Map<String, dynamic> toJson() => _$ImagesToJson(this);
}

@JsonSerializable()
class ImageFixedHeight {
  String height;
  String mp4;
  String mp4_size;
  String size;
  String url;
  String webp;
  String webp_size;
  String width;

  ImageFixedHeight({
    this.height,
    this.mp4,
    this.mp4_size,
    this.size,
    this.url,
    this.webp,
    this.webp_size,
    this.width,
  });

  double get heightValue => double.parse(height);

  factory ImageFixedHeight.fromJson(Map<String, dynamic> json) => _$ImageFixedHeightFromJson(json);
  Map<String, dynamic> toJson() => _$ImageFixedHeightToJson(this);

}