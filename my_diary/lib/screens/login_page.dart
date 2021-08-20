import 'package:flutter/material.dart';
import 'package:my_diary/widgets/create_account_form.dart';
import 'package:my_diary/widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailTextController = TextEditingController();

  final TextEditingController _passwordTextController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  bool isCreatedAccountClicked = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 2,
              child: Container(
                color: Color(0XFFB9C2D1),
              )),
          Text(
            'Sign In',
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              SizedBox(
                width: 300,
                height: 300,
                child: isCreatedAccountClicked
                    ? CreateAccountForm(
                        formKey: _globalKey,
                        emailTextController: _emailTextController,
                        passwordTextController: _passwordTextController,
                      )
                    : LoginForm(
                        formKey: _globalKey,
                        emailTextController: _emailTextController,
                        passwordTextController: _passwordTextController,
                      ),
              ),
              TextButton.icon(
                icon: Icon(Icons.portrait_rounded),
                label: Text(
                  isCreatedAccountClicked
                      ? 'Already have account?'
                      : 'Create Account',
                ),
                style: TextButton.styleFrom(
                  textStyle:
                      TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
                onPressed: () {
                  setState(
                    () {
                      if (!isCreatedAccountClicked) {
                        isCreatedAccountClicked = true;
                      } else {
                        isCreatedAccountClicked = false;
                      }
                    },
                  );
                },
              ),
            ],
          ),
          Expanded(
              flex: 2,
              child: Container(
                color: Color(0XFFB9C2D1),
              ))
        ],
      )),
    );
  }
}
