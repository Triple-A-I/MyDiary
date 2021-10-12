import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_diary/model/diary.dart';

class DeleteEntryDialog extends StatelessWidget {
  const DeleteEntryDialog({
    Key key,
    @required this.diary,
    this.bookCollectionReference,
  }) : super(key: key);

  final Diary diary;
  final CollectionReference<Object> bookCollectionReference;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete Entery?',
        style: TextStyle(color: Colors.red),
      ),
      content: Text(
          'Are you sure you want to delete the entry? \n This action can not be reversed.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection('diaries')
                .doc(diary.id)
                .delete()
                .then((value) {
              return Navigator.of(context).pop();
            });
          },
          child: Text('Delete'),
        ),
      ],
    );
  }
}
