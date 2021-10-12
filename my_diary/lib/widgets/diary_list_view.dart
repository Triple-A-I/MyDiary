import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_diary/model/diary.dart';
import 'package:my_diary/utils/utils.dart';
import 'package:my_diary/widgets/inner_list_card.dart';
import 'package:my_diary/widgets/write_diary_dialog.dart';
import 'package:provider/provider.dart';

class DiaryListView extends StatelessWidget {
  const DiaryListView({
    Key key,
    @required List<Diary> listOfDiaries,
    @required this.selectedDate,
  })  : _listOfDiaries = listOfDiaries,
        super(key: key);
  final DateTime selectedDate;
  final List<Diary> _listOfDiaries;
  @override
  Widget build(BuildContext context) {
    CollectionReference bookCollectionReference =
        FirebaseFirestore.instance.collection('diaries');
    final _descriptionEditingController = TextEditingController();
    final _titleEditingController = TextEditingController();
    final _user = Provider.of<User>(context);
    var _diaryList = this._listOfDiaries;
    var filteredDiaryList = _diaryList.where((element) {
      return (element.userId == _user.uid);
    }).toList();
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.40,
            child: (filteredDiaryList.isEmpty)
                ? ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4.0,
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .3,
                              height: MediaQuery.of(context).size.height * .2,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Safeguard your mmeory on ${formatDate(selectedDate)}',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                    TextButton.icon(
                                      icon: Icon(Icons.lock_outline_sharp),
                                      label: Text('Click to Add an Entry'),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return WriteDiaryDialog(
                                              selectedDate: selectedDate,
                                              descriptionEditingController:
                                                  _descriptionEditingController,
                                              titleEditingController:
                                                  _titleEditingController,
                                            );
                                          },
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: filteredDiaryList.length,
                    itemBuilder: (context, index) {
                      Diary diary = filteredDiaryList[index];
                      return DelayedDisplay(
                        delay: Duration(milliseconds: 1),
                        fadeIn: true,
                        child: Card(
                          elevation: 4.0,
                          child: InnerListCard(
                              selectedDate: this.selectedDate,
                              diary: diary,
                              bookCollectionReference: bookCollectionReference),
                        ),
                      );
                    },
                  ),
          ),
        )
      ],
    );
  }
}
/*

StreamBuilder<QuerySnapshot>(
            stream: bookCollectionReference.snapshots(),
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
                            child: InnerListCard(
                                selectedDate: this.selectedDate,
                                diary: diary,
                                bookCollectionReference:
                                    bookCollectionReference),
                          );
                        },
                      ),
                    ),
                  )
                ],
              );
            })

 */