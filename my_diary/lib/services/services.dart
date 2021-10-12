import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_diary/model/diary.dart';
import 'package:my_diary/model/user.dart';

class DiaryServices {
  final CollectionReference userCollectionReference =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference diaryCollectionReference =
      FirebaseFirestore.instance.collection('diaries');
  Future<void> loginUser(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createUser(
      String displayName, BuildContext context, String uid) async {
    MUser user = MUser(
      avatarUrl: 'https://i.pravatar.cc/150?u=fake@pravatar.com',
      displayName: displayName,
      uid: uid,
      profession: 'Joker',
    );
    await userCollectionReference.add(user.toMap());
  }

  Future<void> update(MUser user, String displayName, String avatarUrl,
      BuildContext context) async {
    MUser updateUser = MUser(
      displayName: displayName,
      avatarUrl: avatarUrl,
      uid: user.uid,
    );

    await userCollectionReference.doc(user.id).update(updateUser.toMap());
  }

  Future<List<Diary>> getSameDateDiaries(DateTime first, String userId) {
    return diaryCollectionReference
        .where('entry_time',
            isGreaterThanOrEqualTo: Timestamp.fromDate(first).toDate())
        .where('entry_time',
            isLessThan:
                Timestamp.fromDate(first.add(Duration(days: 1))).toDate())
        .where('user_id', isEqualTo: userId)
        .get()
        .then((value) {
      // print('items ==> ${value.docs.length}');
      return value.docs.map((diary) {
        return Diary.fromDocument(diary);
      }).toList();
    });
  }

  getLatestDiaries(String uid) {
    return diaryCollectionReference
        .where('user_id', isEqualTo: uid)
        .orderBy('entry_time', descending: true)
        .get()
        .then((value) {
      return value.docs.map((diary) {
        return Diary.fromDocument(diary);
      });
    });
  }

  getEarliestDiaries(String uid) {
    return diaryCollectionReference
        .where('user_id', isEqualTo: uid)
        .orderBy('entry_time', descending: false)
        .get()
        .then((value) {
      return value.docs.map((diary) {
        return Diary.fromDocument(diary);
      });
    });
  }
}
