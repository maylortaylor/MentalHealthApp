import 'package:meta/meta.dart';

class Prompt {
  final String id;
  final String title;
  final String? body;
  final String dateCreated;
  final String step;
  final String? videoUrl;
  final String? photoUrl;

  Prompt({
    required this.id,
    required this.title,
    required this.body,
    required this.dateCreated,
    required this.step,
    this.videoUrl,
    this.photoUrl,
  });

  static Prompt fromMap(Map<String, dynamic> data, String documentId) {
    String id = data['id'];
    String title = data['title'];
    String body = data['body'];
    String dateCreated = data['dateCreated'];
    String step = data['step'];
    String videoUrl = data['videoUrl'];
    String photoUrl = data['photoUrl'];

    return  Prompt(
      id: documentId, 
      title: title,
      body: body,
      dateCreated: dateCreated,
      step: step,
      videoUrl: videoUrl,
      photoUrl: photoUrl);
  }
  
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'title': title,
      'body': body,
      'dateCreated': dateCreated,
      'step': step,
      'videoUrl': videoUrl,
      'photoUrl': photoUrl,
    };

    return map;
  }
}