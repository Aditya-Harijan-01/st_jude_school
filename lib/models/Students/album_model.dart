import 'dart:convert';

class PhotoAlbumResponse {
  final String? statusCode;
  final String? message;
  final List<PhotoAlbum>? data;

  PhotoAlbumResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory PhotoAlbumResponse.fromJson(Map<String, dynamic> json) {
    return PhotoAlbumResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null
          ? List<PhotoAlbum>.from(
              json['data'].map((x) => PhotoAlbum.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'message': message,
        'data': data?.map((x) => x.toJson()).toList(),
      };

  static PhotoAlbumResponse fromRawJson(String str) =>
      PhotoAlbumResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}

class PhotoAlbum {
  final String? id;
  final String? heading;
  final String? coverImage;
  final String? uploadDate;
  final List<AlbumImage>? images;

  PhotoAlbum({
    this.id,
    this.heading,
    this.coverImage,
    this.uploadDate,
    this.images,
  });

  factory PhotoAlbum.fromJson(Map<String, dynamic> json) => PhotoAlbum(
        id: json['id'],
        heading: json['heading'],
        coverImage: json['cover_image'],
        uploadDate: json['upload_date'],
        images: json['images'] != null
            ? List<AlbumImage>.from(
                json['images'].map((x) => AlbumImage.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'heading': heading,
        'cover_image': coverImage,
        'upload_date': uploadDate,
        'images': images?.map((x) => x.toJson()).toList(),
      };
}

/// Each image in an album
class AlbumImage {
  final String? id;
  final String? detailId;
  final String? imgPath;

  AlbumImage({
    this.id,
    this.detailId,
    this.imgPath,
  });

  factory AlbumImage.fromJson(Map<String, dynamic> json) => AlbumImage(
        id: json['id'],
        detailId: json['detail_id'],
        imgPath: json['img_path'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'detail_id': detailId,
        'img_path': imgPath,
      };
}
