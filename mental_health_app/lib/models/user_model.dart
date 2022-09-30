class UserModel {
  String? uid;
  String? email;
  String? displayName;
  String? phoneNumber;
  String? photoUrl;
  String? dateCreated;
  String? lastModified;
  List<String>? pathsAllowed;
  bool isSubscribed = false;

  UserModel(
      {this.uid,
      this.email,
      this.displayName,
      this.phoneNumber,
      this.photoUrl,
      this.dateCreated,
      this.lastModified,
      this.pathsAllowed,
      this.isSubscribed = false,
  });

  static UserModel fromMap(Map<String, dynamic> data, String userId) {
    String uid = data['uid'];
    String email = data['email'];
    String displayName = data['displayName'];
    String phoneNumber = data['phoneNumber'] ?? '';
    String photoUrl = data['photoUrl'] ?? '';
    String dateCreated = data['dateCreated'] ?? '';
    String lastModified = data['lastModified'] ?? '';
    // List<String> pathsAllowed = data['pathsAllowed'] ?? '';
    List<String> pathsAllowed = List<String>.from(data['pathsAllowed'] ?? "");
    bool isSubscribed = data['isSubscribed'] ?? false;

    return  UserModel(
      uid: userId, 
      email: email,
      displayName: displayName,
      phoneNumber: phoneNumber,
      photoUrl: photoUrl,
      dateCreated: dateCreated,
      lastModified: lastModified,
      pathsAllowed: pathsAllowed,
      isSubscribed: isSubscribed,
      );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'dateCreated': dateCreated,
      'lastModified': lastModified,
      'pathsAllowed': pathsAllowed,
      'isSubscribed': isSubscribed
    };

    return map;
  }
}