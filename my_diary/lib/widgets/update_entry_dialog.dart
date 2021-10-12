import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:my_diary/model/diary.dart';
import 'package:my_diary/utils/utils.dart';
import 'package:my_diary/widgets/delete_entry_dialog.dart';
import 'package:my_diary/widgets/inner_list_card.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UpdateEntryDialog extends StatefulWidget {
  const UpdateEntryDialog({
    Key key,
    @required this.diary,
    @required TextEditingController titleTextController,
    @required TextEditingController descriptionTextController,
    @required CollectionReference linkReference,
    @required DateTime selectedDate,
    this.cloudFile,
    this.fileBytes,
    this.imageWidget,
    this.widget,
  })  : _titleTextController = titleTextController,
        _descriptionTextController = descriptionTextController,
        _linkReference = linkReference,
        _selectedDate = selectedDate,
        super(key: key);

  final Diary diary;
  final TextEditingController _titleTextController;
  final TextEditingController _descriptionTextController;
  final html.File cloudFile;
  final fileBytes;
  final Image imageWidget;
  final CollectionReference _linkReference;
  final DateTime _selectedDate;
  final InnerListCard widget;

  @override
  _UpdateEntryDialogState createState() => _UpdateEntryDialogState();
}

class _UpdateEntryDialogState extends State<UpdateEntryDialog> {
  var _fileBytes;
  Image _imageWidget;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5.0,
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
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
                    onPressed: () {
                      var _user = FirebaseAuth.instance.currentUser;
                      final _fieldNotEmpty =
                          widget._descriptionTextController.text.isNotEmpty &&
                              widget._titleTextController.text.isNotEmpty;
                      final diaryTitleChanged = widget.diary.title !=
                          widget._titleTextController.text;
                      final diaryEntryChanged = widget.diary.entry !=
                          widget._descriptionTextController.text;
                      final diaryUpdate = diaryEntryChanged ||
                          diaryTitleChanged ||
                          _fileBytes != null;
                      firebase_storage.FirebaseStorage fs =
                          firebase_storage.FirebaseStorage.instance;
                      final dateTime = DateTime.now();
                      final path = '$dateTime';
                      if (_fieldNotEmpty && diaryUpdate) {
                        widget._linkReference.doc(widget.diary.id).update(Diary(
                              userId: _user.uid,
                              entryTime: Timestamp.fromDate(
                                  // widget.widget.selectedDate,
                                  DateTime.now()),
                              entry: widget._descriptionTextController.text,
                              author: _user.email.split('@')[0],
                              title: widget._titleTextController.text,
                              photoUrls: (widget.diary.photoUrls != null)
                                  ? widget.diary.photoUrls
                                  : null,
                            ).toMap());
                        if (_fileBytes != null) {
                          firebase_storage.SettableMetadata metadata =
                              firebase_storage.SettableMetadata(
                                  contentType: 'image/jpeg',
                                  customMetadata: {
                                'picked-file-path': path,
                              });
                          fs
                              .ref()
                              .child(
                                  'images/$path${FirebaseAuth.instance.currentUser.uid}')
                              .putData(_fileBytes, metadata)
                              .then((value) {
                            return value.ref.getDownloadURL().then((value) {
                              widget._linkReference
                                  .doc(widget.diary.id)
                                  .update({'photo_list': value.toString()});
                            });
                          });
                        }
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Done'),
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white12,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                              splashRadius: 25,
                              icon: Icon(Icons.image_rounded),
                              onPressed: () async {
                                await getMultipleImageInfos();
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                              splashRadius: 25,
                              icon: Icon(Icons.delete_outline),
                              color: Colors.red,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DeleteEntryDialog(
                                      diary: widget.diary,
                                      bookCollectionReference:
                                          widget._linkReference,
                                    );
                                  },
                                ).then((value) => Navigator.of(context).pop());
                              }),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${formatDateFromTimeStamp(this.widget.diary.entryTime)}',
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .4,
                            width: MediaQuery.of(context).size.width * .6,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: (_imageWidget != null)
                                  ? _imageWidget
                                  : Image.network(
                                      (widget.diary.photoUrls == null)
                                          ? 'https://picsum.photos/400/200'
                                          : widget.diary.photoUrls),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .5,
                            child: Form(
                              child: Column(children: [
                                TextFormField(
                                  controller: widget._titleTextController,
                                  decoration:
                                      InputDecoration(hintText: 'Title...'),
                                ),
                                TextFormField(
                                  maxLines: null,
                                  maxLength: null,
                                  controller: widget._descriptionTextController,
                                  decoration: InputDecoration(
                                      hintText: 'Write your thoughts here...'),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getMultipleImageInfos() async {
    var mediaData = await ImagePickerWeb.getImageInfo;
    // String mimeType = mime(Path.basename(mediaData.fileName));
    // html.File mediaFile =
    //     new html.File(mediaData.data, mediaData.fileName, {'type': mimeType});

    setState(() {
      // _cloudFile = mediaFile;
      _fileBytes = mediaData.data;
      _imageWidget = Image.memory(mediaData.data);
    });
  }
}
