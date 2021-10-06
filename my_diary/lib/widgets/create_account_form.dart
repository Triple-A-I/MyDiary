import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_diary/screens/main_page.dart';
import 'package:my_diary/services/services.dart';
import 'package:my_diary/widgets/input_decorator.dart';

class CreateAccountForm extends StatelessWidget {
  const CreateAccountForm({
    Key key,
    GlobalKey<FormState> formKey,
    @required TextEditingController emailTextController,
    @required TextEditingController passwordTextController,
  })  : _emailTextController = emailTextController,
        _passwordTextController = passwordTextController,
        _globalKey = formKey,
        super(key: key);

  final TextEditingController _emailTextController;
  final TextEditingController _passwordTextController;
  final GlobalKey<FormState> _globalKey;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _globalKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'Please Enter a valid email and password that at least is 6 characters.'),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                validator: (value) {
                  return value.isEmpty ? 'Please enter email' : null;
                },
                controller: _emailTextController,
                decoration: buildInputDecoration('email', 'Example@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                validator: (value) {
                  return value.isEmpty ? 'Please enter password' : null;
                },
                obscureText: true,
                controller: _passwordTextController,
                decoration: buildInputDecoration('password', ''),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                backgroundColor: Colors.green,
                textStyle: TextStyle(
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                if (_globalKey.currentState.validate()) {
                  String email = _emailTextController.text;
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: _passwordTextController.text)
                      .then(
                    (value) {
                      print('value: $value, user: ${value.user}');
                      if (value.user != null) {
                        String displayName = email.split('@')[0];
                        DiaryServices()
                            .createUser(displayName, context, value.user.uid)
                            .then((value) {
                          DiaryServices()
                              .loginUser(email, _passwordTextController.text)
                              .then((value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainPage(),
                              ),
                            );
                          });
                        });
                      }
                    },
                  );
                }
              },
              child: Text('Create Account'),
            ),
          ],
        ));
  }
}
