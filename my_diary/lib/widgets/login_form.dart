import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_diary/screens/main_page.dart';
import 'package:my_diary/widgets/input_decorator.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
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
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                    email: _emailTextController.text,
                    password: _passwordTextController.text,
                  )
                      .then(
                    (value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            _emailTextController.text = '';
                            _passwordTextController.text = '';
                            return MainPage();
                          },
                        ),
                      );
                    },
                  );
                }
              },
              child: Text('Sign In'),
            ),
          ],
        ));
  }
}
