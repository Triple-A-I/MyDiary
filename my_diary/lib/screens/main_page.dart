import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_diary/model/diary.dart';
import 'package:my_diary/model/user.dart';
import 'package:my_diary/services/services.dart';
import 'package:my_diary/widgets/create_profile.dart';
import 'package:my_diary/widgets/diary_list_view.dart';
import 'package:my_diary/widgets/write_diary_dialog.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var userDiaryEntryFilteredList;
  String _dropDownText;
  DateTime _selectedDate = DateTime.now();
  TextEditingController _titleEditingController = TextEditingController();
  TextEditingController _descriptionEditingController = TextEditingController();
  // List<Diary> _listOfDiaries = [];
  @override
  Widget build(BuildContext context) {
    var _listOfDiaries = Provider.of<List<Diary>>(context);
    var _user = Provider.of<User>(context);
    var latestFilteredDiariesStream;
    var earliestFilteredDiariesStream;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        elevation: 4,
        title: Row(
          children: [
            Text(
              'My',
              style: TextStyle(fontSize: 39, color: Colors.blueGrey.shade400),
            ),
            Text(
              'Diary',
              style: TextStyle(fontSize: 39, color: Colors.green.shade400),
            )
          ],
        ),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  items: <String>['Latest', 'Earliest'].map((String value) {
                    return DropdownMenuItem<String>(
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.grey),
                      ),
                      value: value,
                    );
                  }).toList(),
                  hint: _dropDownText == null
                      ? Text('Select')
                      : Text(_dropDownText),
                  onChanged: (value) {
                    if (value == 'Latest') {
                      setState(() {
                        _dropDownText = value;
                      });
                      _listOfDiaries.clear();
                      latestFilteredDiariesStream =
                          DiaryServices().getLatestDiaries(_user.uid);
                      latestFilteredDiariesStream.then((value) {
                        for (var item in value) {
                          setState(() {
                            _listOfDiaries.add(item);
                          });
                        }
                      });
                    } else if (value == 'Earliest') {
                      setState(() {
                        _dropDownText = value;
                      });
                      _listOfDiaries.clear();
                      earliestFilteredDiariesStream =
                          DiaryServices().getEarliestDiaries(_user.uid);
                      earliestFilteredDiariesStream.then((value) {
                        for (var item in value) {
                          setState(() {
                            _listOfDiaries.add(item);
                          });
                        }
                      });
                    }
                  },
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return AlertDialog(
                      content: Container(
                        child: Text(snapshot.error),
                      ),
                    );
                  }
                  final listStreamiUser = snapshot.data.docs.map((docs) {
                    return MUser.fromDocument(docs);
                  }).where((muser) {
                    return (muser.uid == FirebaseAuth.instance.currentUser.uid);
                  }).toList();

                  MUser currentUser = listStreamiUser[0];
                  return CreateProfile(currentUser: currentUser);
                },
              ),
            ],
          )
        ],
      ),
      body: Scrollbar(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border(
                    right: BorderSide(
                      width: .4,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(38.0),
                      child: SfDateRangePicker(
                        onSelectionChanged: (dateRangePickerSelection) {
                          setState(() {
                            _selectedDate = dateRangePickerSelection.value;
                            _listOfDiaries.clear();
                            userDiaryEntryFilteredList = DiaryServices()
                                .getSameDateDiaries(
                                    Timestamp.fromDate(_selectedDate).toDate(),
                                    FirebaseAuth.instance.currentUser.uid);
                            userDiaryEntryFilteredList.then((value) {
                              for (var item in value) {
                                setState(() {
                                  _listOfDiaries.add(item);
                                });
                              }
                            });
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(38.0),
                      child: Card(
                        elevation: 4,
                        child: TextButton.icon(
                          icon: Icon(
                            Icons.add,
                            size: 40,
                            color: Colors.greenAccent,
                          ),
                          label: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Write New',
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return WriteDiaryDialog(
                                  selectedDate: _selectedDate,
                                  titleEditingController:
                                      _titleEditingController,
                                  descriptionEditingController:
                                      _descriptionEditingController,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: DiaryListView(
                selectedDate: _selectedDate,
                listOfDiaries: _listOfDiaries,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return WriteDiaryDialog(
                selectedDate: _selectedDate,
                titleEditingController: _titleEditingController,
                descriptionEditingController: _descriptionEditingController,
              );
            },
          );
        },
        child: Icon(Icons.add),
        tooltip: 'add',
      ),
    );
  }
}
