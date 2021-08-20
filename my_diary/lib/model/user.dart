import 'package:cloud_firestore/cloud_firestore.dart';

class MUser {
  String id;
  String uid;
  String displayName;
  String profession;
  String avatarUrl;
  MUser({
    this.id,
    this.uid,
    this.profession,
    this.displayName,
    this.avatarUrl,
  });
  factory MUser.fromDocument(QueryDocumentSnapshot data) {
    return MUser(
      id: data.id,
      uid: data.get('uid'),
      displayName: data.get('display_name'),
      avatarUrl: data.get('avatar_url'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'display_name': displayName,
      'profession': profession,
      'avatar_url': avatarUrl,
    };
  }
}
