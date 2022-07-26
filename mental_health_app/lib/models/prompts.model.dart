import 'package:meta/meta.dart';

class Prompt {
  static const String columnId = "_id";
  static const String columnTitle = "promptTitle";
  static const String columnBody = "promptBody";
  static const String columnUrl = "url";
  static const String columnPhotoUrl = "photo";
  static const String columnDateCreated = "dateCreated";

  Prompt({
    required this.title,
    required this.body,
    required this.dateCreated,
    this.url,
    this.photoUrl,
  });

  final String title;
  final String body;
  final String? url;
  final String? photoUrl;
  final String dateCreated;

  Map toMap() {
    Map<String, dynamic> map = {
      columnTitle: title,
      columnDateCreated: dateCreated,
      columnBody: body,
      columnUrl: url,
      columnPhotoUrl: photoUrl,
    };

    return map;
  }

  static Prompt fromJson(Map map) {
    return  Prompt(
        title: map[columnTitle] ?? "",
        body: map[columnBody] ?? "",
        dateCreated: map[columnDateCreated],
        url: map[columnUrl] ?? "",
        photoUrl: map[columnPhotoUrl] ?? "");
  }
}