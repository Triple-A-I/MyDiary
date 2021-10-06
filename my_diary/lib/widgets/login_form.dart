import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_diary/screens/main_page.dart';
import 'package:my_diary/widgets/input_decorator.dart';

class LoginForm extends StatefulWidget {
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
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isLogin = false;
  @override
  Widget build(BuildContext context) {
    return isLogin
        ? Center(child: LinearProgressIndicator())
        : Form(
            key: widget._globalKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    validator: (value) {
                      return value.isEmpty ? 'Please enter email' : null;
                    },
                    controller: widget._emailTextController,
                    decoration:
                        buildInputDecoration('email', 'Example@gmail.com'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    validator: (value) {
                      return value.isEmpty ? 'Please enter password' : null;
                    },
                    obscureText: true,
                    controller: widget._passwordTextController,
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
                    if (widget._globalKey.currentState.validate()) {
                      setState(() {
                        isLogin = true;
                      });
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: widget._emailTextController.text,
                        password: widget._passwordTextController.text,
                      )
                          .then(
                        (value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                widget._emailTextController.text = '';
                                widget._passwordTextController.text = '';

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
            ),
          );
  }
}
