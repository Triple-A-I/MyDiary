import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_diary/model/user.dart';
import 'package:my_diary/widgets/create_profile.dart';
import 'package:my_diary/widgets/write_diary_dialog.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _dropDownText;
  @override
  Widget build(BuildContext context) {
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
                    } else if (value == 'Earliest') {
                      setState(() {
                        _dropDownText = value;
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
      body: Row(
        children: [
          Expanded(
            flex: 1,
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
                      onSelectionChanged: (dateRangePickerSelection) {},
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
                              return WriteDiaryDialog();
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
            flex: 3,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: 8,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Card(
                                    elevation: 4.0,
                                    child: ListTile(
                                      title: Text('Hello'),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        tooltip: 'add',
      ),
    );
  }
}
