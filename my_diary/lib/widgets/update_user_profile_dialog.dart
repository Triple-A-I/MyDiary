import 'package:flutter/material.dart';
import 'package:my_diary/model/user.dart';
import 'package:my_diary/services/services.dart';

class UpdateUserProfileDialog extends StatelessWidget {
  const UpdateUserProfileDialog({
    Key key,
    @required this.currentUser,
    @required TextEditingController avatarUrlTextController,
    @required TextEditingController displayNameTextController,
  })  : _avatarUrlTextController = avatarUrlTextController,
        _displayNameTextController = displayNameTextController,
        super(key: key);

  final MUser currentUser;
  final TextEditingController _avatarUrlTextController;
  final TextEditingController _displayNameTextController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Editing ${currentUser.displayName}',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _avatarUrlTextController,
                    ),
                    TextFormField(
                      controller: _displayNameTextController,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextButton(
                        child: Text('Update'),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            side: BorderSide(color: Colors.green, width: 1),
                          ),
                        ),
                        onPressed: () {
                          DiaryServices().update(
                              currentUser,
                              _displayNameTextController.text,
                              _avatarUrlTextController.text,
                              context);
                          Future.delayed(Duration(milliseconds: 200))
                              .then((value) {
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
