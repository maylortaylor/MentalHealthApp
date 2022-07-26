import 'package:meta/meta.dart';

class Prompt {
  final String id;
  final String title;
  final String? body;
  final String? textPrompt;
  final List<String?> textPrompts;
  final String dateCreated;
  final String step;
  final String? videoUrl;
  final String? videoName;
  final String? photoUrl;
  final String? pdfUrl;

  Prompt({
    required this.id,
    required this.title,
    required this.body,
    required this.textPrompt,
    required this.textPrompts,
    required this.dateCreated,
    required this.step,
    this.videoUrl,
    this.videoName,
    this.photoUrl,
    this.pdfUrl,
  });

  static Prompt fromMap(Map<String, dynamic> data) {
    String id = data['id'];
    String dateCreated = data['dateCreated'];
    String step = data['step'];
    String title = data['title'] ?? '';
    String body = data['body'] ?? '';
    String textPrompt = data['textPrompt'] ?? '';
    List<String> textPrompts = List<String>.from(data['textPrompts'] ?? '');
    String videoUrl = data['videoUrl'] ?? '';
    String videoName = data['videoName'] ?? '';
    String photoUrl = data['photoUrl'] ?? '';
    String pdfUrl = data['pdfUrl'] ?? '';

    return  Prompt(
      id: id, 
      title: title,
      body: body,
      textPrompt: textPrompt,
      textPrompts: textPrompts,
      dateCreated: dateCreated,
      step: step,
      videoUrl: videoUrl,
      videoName: videoName,
      photoUrl: photoUrl,
      pdfUrl: pdfUrl);
  }
  
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'title': title,
      'body': body,
      'textPrompt': textPrompt,
      'textPrompts': textPrompts,
      'dateCreated': dateCreated,
      'step': step,
      'videoUrl': videoUrl,
      'videoName': videoName,
      'photoUrl': photoUrl,
      'pdfUrl': pdfUrl,
    };

    return map;
  }
}