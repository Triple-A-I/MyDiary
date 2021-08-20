import 'package:flutter/material.dart';
import 'package:my_diary/screens/login_page.dart';

class GettingStartedPage extends StatelessWidget {
  const GettingStartedPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CircleAvatar(
        backgroundColor: Color(0XFFF5F6F8),
        child: Column(
          children: [
            Spacer(),
            Text('MyDiary.', style: Theme.of(context).textTheme.headline3),
            SizedBox(
              height: 40,
            ),
            Text(
              '"Document your life"',
              style: TextStyle(
                  fontSize: 29,
                  color: Colors.black26,
                  fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 50),
            Container(
              width: 220,
              height: 40,
              child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ));
                  },
                  icon: Icon(Icons.login_outlined),
                  label: Text('sign in to get started')),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
