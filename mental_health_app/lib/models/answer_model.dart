class AnswerModel {
  String step;
  String category;
  List<String> answerText;
  String? dateCreated;
  String? lastModified;
  bool watchedVideo = false;

  AnswerModel(
      {required this.step,
      required this.category,
      required this.answerText,
      required this.watchedVideo,
      this.dateCreated,
      this.lastModified
    });

  static AnswerModel fromMap(Map<String, dynamic> data, String userId) {
    String step = data['step'];
    String category = data['category'] ?? '';
    List<String> answerText = data['answerText'] ?? '';
    String dateCreated = data['dateCreated'] ?? DateTime.now().toIso8601String();
    String lastModified = data['lastModified'] ?? DateTime.now().toIso8601String();
    bool watchedVideo = data['watchedVideo'] ?? false;

    return  AnswerModel(
      step: step,
      category: category,
      answerText: answerText,
      watchedVideo: watchedVideo,
      dateCreated: dateCreated,
      lastModified: lastModified,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'step': step,
      'category': category,
      'answerText': answerText,
      'watchedVideo': watchedVideo,
      'dateCreated': dateCreated,
      'lastModified': lastModified,
    };

    return map;
  }
}