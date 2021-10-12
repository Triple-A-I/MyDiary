import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_diary/model/diary.dart';
import 'package:my_diary/utils/utils.dart';
import 'package:my_diary/widgets/delete_entry_dialog.dart';
import 'package:my_diary/widgets/update_entry_dialog.dart';

class InnerListCard extends StatelessWidget {
  const InnerListCard({
    Key key,
    @required this.selectedDate,
    @required this.diary,
    @required this.bookCollectionReference,
  }) : super(key: key);

  final Diary diary;
  final CollectionReference<Object> bookCollectionReference;
  final DateTime selectedDate;
  @override
  Widget build(BuildContext context) {
    final TextEditingController _titleTextController =
        TextEditingController(text: diary.title);
    final TextEditingController _descriptionTextController =
        TextEditingController(text: diary.entry);
    return Column(
      children: [
        ListTile(
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        return DeleteEntryDialog(diary: diary);
                      },
                    );
                  },
                )
              ],
            ),
          ),
          subtitle: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
              Image.network((diary.photoUrls == null)
                  ? 'https://picsum.photos/400/200'
                  : diary.photoUrls),
              Row(
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            diary.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(diary.entry),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .3,
                        child: Row(
                          children: [
                            Text(
                              '${formatDateFromTimeStamp(diary.entryTime)}',
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return UpdateEntryDialog(
                                        widget: this,
                                        linkReference: bookCollectionReference,
                                        diary: diary,
                                        titleTextController:
                                            _titleTextController,
                                        selectedDate: selectedDate,
                                        descriptionTextController:
                                            _descriptionTextController);
                                  },
                                );
                              },
                            ),
                            IconButton(
                                icon: Icon(Icons.delete_forever_rounded),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return DeleteEntryDialog(
                                        bookCollectionReference:
                                            bookCollectionReference,
                                        diary: diary,
                                      );
                                    },
                                  );
                                })
                          ],
                        ),
                      )
                    ],
                  ),
                  content: ListTile(
                    subtitle: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '•${formatDateFromTimeStampHour(diary.entryTime)}',
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .60,
                          height: MediaQuery.of(context).size.height * .5,
                          child: Image.network((diary.photoUrls == null)
                              ? 'https://picsum.photos/400/200'
                              : diary.photoUrls),
                        ),
                        Row(
                          children: [
                            Flexible(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    diary.title,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(diary.entry),
                                ),
                              ],
                            ))
                          ],
                        )
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
