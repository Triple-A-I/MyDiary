import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:my_diary/model/diary.dart';
import 'package:my_diary/utils/utils.dart';
import 'dart:html' as html;
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// ignore: must_be_immutable
class WriteDiaryDialog extends StatefulWidget {
  WriteDiaryDialog(
      {Key key,
      this.selectedDate,
      TextEditingController titleEditingController,
      TextEditingController descriptionEditingController})
      : _titleTextController = titleEditingController,
        _descriptionTextController = descriptionEditingController,
        super(key: key);
  final TextEditingController _titleTextController;
  final TextEditingController _descriptionTextController;
  DateTime selectedDate;

  @override
  _WriteDiaryDialogState createState() => _WriteDiaryDialogState();
}

class _WriteDiaryDialogState extends State<WriteDiaryDialog> {
  String _text = 'Done';
  CollectionReference diaryCollectionReference =
      FirebaseFirestore.instance.collection('diaries');
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Discard'),
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () async {
                      firebase_storage.FirebaseStorage fs =
                          firebase_storage.FirebaseStorage.instance;

                      final dateTime = DateTime.now();
                      final path = '$dateTime';

                      final _fieldsNotEmpty = widget._titleTextController.text
                              .toString()
                              .isNotEmpty &&
                          widget._descriptionTextController.text
                              .toString()
                              .isNotEmpty;
                      String currId;
                      if (_fieldsNotEmpty) {
                        var newdoc = await diaryCollectionReference
                            .add(Diary(
                          title: widget._titleTextController.text,
                          entry: widget._descriptionTextController.text,
                          author: FirebaseAuth.instance.currentUser.email
                              .split('@')[0],
                          userId: FirebaseAuth.instance.currentUser.uid,
                          photoUrls: FirebaseAuth.instance.currentUser.photoURL,
                          entryTime: Timestamp.fromDate(widget.selectedDate),
                        ).toMap())
                            .then((value) {
                          setState(() {
                            currId = value.id;
                          });
                          return null;
                        });

                        if (_fileBytes != null) {
                          firebase_storage.SettableMetadata metadata =
                              firebase_storage.SettableMetadata(
                                  contentType: 'image/jpeg',
                                  customMetadata: {
                                'picked-file-path': path,
                              });
                          await fs
                              .ref()
                              .child(
                                  'images/$path${FirebaseAuth.instance.currentUser.uid}')
                              .putData(_fileBytes, metadata)
                              .then((value) {
                            return value.ref.getDownloadURL().then((value) {
                              diaryCollectionReference
                                  .doc(currId)
                                  .update({'photo_list': value.toString()});
                            });
                          });
                        }

                        setState(() {
                          _text = 'Saving...';
                        });
                        Future.delayed(
                          Duration(milliseconds: 4000),
                        ).then((value) => Navigator.pop(context));
                      }
                    },
                    child: Text(_text),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.green,
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        side: BorderSide(
                          color: Colors.green,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white12,
                    child: Column(
                      children: [
                        IconButton(
                          splashRadius: 26,
                          icon: Icon(Icons.image_rounded),
                          onPressed: () async {
                            await getMultipleImageInfos();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatDate(widget.selectedDate),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Form(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.8 /
                                        2,
                                    child: _imageWidget,
                                  ),
                                  TextFormField(
                                    controller: widget._titleTextController,
                                    decoration:
                                        InputDecoration(hintText: 'Title...'),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      maxLines: null,
                                      maxLength: null,
                                      controller:
                                          widget._descriptionTextController,
                                      decoration: InputDecoration(
                                          hintText:
                                              'Write your thoughts here...'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  html.File _cloudFile;
  var _fileBytes;
  Image _imageWidget;

  Future<void> getMultipleImageInfos() async {
    var mediaData = await ImagePickerWeb.getImageInfo;
    String mimeType = mime(Path.basename(mediaData.fileName));
    html.File mediaFile =
        new html.File(mediaData.data, mediaData.fileName, {'type': mimeType});

    setState(() {
      _cloudFile = mediaFile;
      _fileBytes = mediaData.data;
      _imageWidget = Image.memory(mediaData.data);
    });
  }
}
