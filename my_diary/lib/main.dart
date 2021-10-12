import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_diary/model/diary.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_diary/screens/get_start_page.dart';
import 'package:my_diary/screens/login_page.dart';
import 'package:my_diary/screens/main_page.dart';
import 'package:my_diary/screens/page_not_found.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final userDiaryDataStream =
      // ignore: top_level_function_literal_block
      FirebaseFirestore.instance.collection('diaries').snapshots()
          // ignore: top_level_function_literal_block
          .map((diaries) {
    return diaries.docs.map((diary) {
      return Diary.fromDocument(diary);
    }).toList();
  });
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider(
            create: (context) => FirebaseAuth.instance.authStateChanges(),
            initialData: null),
        StreamProvider<List<Diary>>(
            create: (context) => userDiaryDataStream, initialData: []),
      ],
      child: MaterialApp(
        title: 'My Diary',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.green,
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) {
            return RouteController(settingsName: settings.name);
          });
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => PageNotFound(),
          );
        },
      ),
    );
  }
}

class RouteController extends StatelessWidget {
  final String settingsName;

  RouteController({@required this.settingsName});
  @override
  Widget build(BuildContext context) {
    final userSignedIn = Provider.of<User>(context) != null;
    final signedInGotoMain = userSignedIn && settingsName == '/main';
    final notSignedInGoToMain = !userSignedIn && settingsName == '/main';
    if (settingsName == '/') {
      return GettingStartedPage();
    } else if (settingsName == '/main' || notSignedInGoToMain) {
      return LoginPage();
    } else if (settingsName == '/login' || notSignedInGoToMain) {
      return LoginPage();
    } else if (signedInGotoMain) {
      return MainPage();
    } else {
      return PageNotFound();
    }
  }
}


// class GetInfo extends StatelessWidget {
//   const GetInfo({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('diaries').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('Something went wrong ${snapshot.error}');
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           return ListView(
//             children: snapshot.data.docs.map((DocumentSnapshot document) {
//               return ListTile(
//                 title: Text(document.get('display_name')),
//                 subtitle: Text(document.get('profession')),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }
