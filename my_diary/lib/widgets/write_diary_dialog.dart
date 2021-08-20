import 'package:flutter/material.dart';

class WriteDiaryDialog extends StatelessWidget {
  const WriteDiaryDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _titleTextController = TextEditingController();
    final _descriptionTextController = TextEditingController();
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
                    onPressed: () {},
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
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white12,
                    child: Column(
                      children: [
                        IconButton(
                          splashRadius: 26,
                          icon: Icon(Icons.image_rounded),
                          onPressed: () {},
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
                          'Jun 23, 2033',
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Form(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.8 /
                                      2,
                                  child: Container(
                                      // width: 700,
                                      // color: Colors.green,
                                      // child: Text('image here'),
                                      ),
                                ),
                                TextFormField(
                                  controller: _titleTextController,
                                  decoration:
                                      InputDecoration(hintText: 'Title...'),
                                ),
                                TextFormField(
                                  maxLines: null,
                                  controller: _descriptionTextController,
                                  decoration: InputDecoration(
                                      hintText: 'Write your thoughts here...'),
                                ),
                              ],
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
}
