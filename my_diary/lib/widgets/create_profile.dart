import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_diary/model/user.dart';
import 'package:my_diary/widgets/update_user_profile_dialog.dart';

class CreateProfile extends StatelessWidget {
  const CreateProfile({
    Key key,
    @required this.currentUser,
  }) : super(key: key);

  final MUser currentUser;

  @override
  Widget build(BuildContext context) {
    final _avatarUrlTextController =
        TextEditingController(text: currentUser.avatarUrl);
    final _displayNameTextController =
        TextEditingController(text: currentUser.displayName);
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              Expanded(
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(currentUser.avatarUrl),
                      backgroundColor: Colors.transparent,
                      radius: 30,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return UpdateUserProfileDialog(
                            currentUser: currentUser,
                            avatarUrlTextController: _avatarUrlTextController,
                            displayNameTextController:
                                _displayNameTextController);
                      },
                    );
                  },
                ),
              ),
              Text(
                currentUser.displayName,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.logout,
              size: 19,
              color: Colors.red,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.of(context).pop();
              });
            },
          ),
        ],
      ),
    );
  }
}
