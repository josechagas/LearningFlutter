// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemModel _$ItemModelFromJson(Map<String, dynamic> json) {
  return ItemModel(
    type: json['type'] as String,
    id: json['id'] as String,
    url: json['url'] as String,
    slug: json['slug'] as String,
    bitlyGifUrl: json['bitlyGifUrl'] as String,
    bitlyUrl: json['bitlyUrl'] as String,
    embedUrl: json['embedUrl'] as String,
    username: json['username'] as String,
    source: json['source'] as String,
    title: json['title'] as String,
    rating: json['rating'] as String,
    contentUrl: json['contentUrl'] as String,
    sourceTld: json['sourceTld'] as String,
    sourcePostUrl: json['sourcePostUrl'] as String,
    isSticker: json['isSticker'] as bool,
    importDatetime: json['importDatetime'] == null
        ? null
        : DateTime.parse(json['importDatetime'] as String),
    trendingDatetime: json['trendingDatetime'] == null
        ? null
        : DateTime.parse(json['trendingDatetime'] as String),
    images: json['images'] == null
        ? null
        : Images.fromJson(json['images'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ItemModelToJson(ItemModel instance) => <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'url': instance.url,
      'slug': instance.slug,
      'bitlyGifUrl': instance.bitlyGifUrl,
      'bitlyUrl': instance.bitlyUrl,
      'embedUrl': instance.embedUrl,
      'username': instance.username,
      'source': instance.source,
      'title': instance.title,
      'rating': instance.rating,
      'contentUrl': instance.contentUrl,
      'sourceTld': instance.sourceTld,
      'sourcePostUrl': instance.sourcePostUrl,
      'isSticker': instance.isSticker,
      'importDatetime': instance.importDatetime?.toIso8601String(),
      'trendingDatetime': instance.trendingDatetime?.toIso8601String(),
      'images': instance.images,
    };

GiphyApiResponse _$GiphyApiResponseFromJson(Map<String, dynamic> json) {
  return GiphyApiResponse(
    data: (json['data'] as List)
        ?.map((e) =>
            e == null ? null : ItemModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GiphyApiResponseToJson(GiphyApiResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

Images _$ImagesFromJson(Map<String, dynamic> json) {
  return Images(
    fixed_height: json['fixed_height'] == null
        ? null
        : ImageFixedHeight.fromJson(
            json['fixed_height'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      'fixed_height': instance.fixed_height,
    };

ImageFixedHeight _$ImageFixedHeightFromJson(Map<String, dynamic> json) {
  return ImageFixedHeight(
    height: json['height'] as String,
    mp4: json['mp4'] as String,
    mp4_size: json['mp4_size'] as String,
    size: json['size'] as String,
    url: json['url'] as String,
    webp: json['webp'] as String,
    webp_size: json['webp_size'] as String,
    width: json['width'] as String,
  );
}

Map<String, dynamic> _$ImageFixedHeightToJson(ImageFixedHeight instance) =>
    <String, dynamic>{
      'height': instance.height,
      'mp4': instance.mp4,
      'mp4_size': instance.mp4_size,
      'size': instance.size,
      'url': instance.url,
      'webp': instance.webp,
      'webp_size': instance.webp_size,
      'width': instance.width,
    };
