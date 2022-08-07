import 'package:meta/meta.dart';

class Prompt {
  static const String columnId = "id";
  static const String columnTitle = "title";
  static const String columnBody = "body";
  static const String columnStep = "step";
  static const String columnVideoUrl = "videoUrl";
  static const String columnDateCreated = "dateCreated";

  Prompt({
    required this.title,
    required this.body,
    required this.dateCreated,
    required this.step,
    this.videoUrl,
    this.photoUrl,
  });

  final String title;
  final String? body;
  final String step;
  final String? videoUrl;
  final String? photoUrl;
  final String dateCreated;

  Map toMap() {
    Map<String, dynamic> map = {
      columnTitle: title,
      columnDateCreated: dateCreated,
      columnBody: body,
      columnVideoUrl: videoUrl,
    };

    return map;
  }

  static Prompt fromJson(Map map) {
    return  Prompt(
        title: map[columnTitle] ?? "",
        body: map[columnBody] ?? "",
        dateCreated: map[columnDateCreated],
        videoUrl: map[columnVideoUrl] ?? "",
        step: map[columnStep] ?? "");
  }
}