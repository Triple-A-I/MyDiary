import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_diary/model/diary.dart';
import 'package:my_diary/screens/main_page.dart';
import 'package:my_diary/utils/utils.dart';
import 'package:my_diary/widgets/delete_entry_dialog.dart';

class DiaryListView extends StatelessWidget {
  const DiaryListView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('diaries').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                  width: MediaQuery.of(context).size.width * .3,
                  child: LinearProgressIndicator()),
            );
          }
          var filteredList = snapshot.data.docs.map((diary) {
            return Diary.fromDocument(diary);
          }).where((item) {
            return item.userId == FirebaseAuth.instance.currentUser.uid;
          }).toList();
          return Column(
            children: [
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.40,
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      Diary diary = filteredList[index];
                      return Card(
                        elevation: 4.0,
                        child: Column(
                          children: [
                            ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${formatDateFromTimeStamp(diary.entryTime)}',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton.icon(
                                      icon: Icon(
                                        Icons.delete_forever,
                                        color: Colors.grey,
                                      ),
                                      label: Text(''),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return DeleteEntryDialog(
                                                diary: diary);
                                          },
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                              subtitle: Column(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '•${formatDateFromTimeStampHour(diary.entryTime)}',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        TextButton.icon(
                                          onPressed: () {},
                                          icon: Icon(Icons.more_horiz),
                                          label: Text(''),
                                        )
                                      ]),
                                  Image.network(
                                      'https://picsum.photos/400/200'),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                diary.title,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(diary.entry),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          );
        });
  }
}
