import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:group/models/user.dart';
import 'package:group/screens/projects/projects.dart';
import 'package:group/screens/wrapper.dart';
import 'package:group/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel>.value(
      value: AuthService().user,
      child: MaterialApp(
        routes: {
          '/projects': (context) => ProjectsPage(),
        },
        theme: ThemeData(
          fontFamily: 'SpecialElite',
          textTheme: TextTheme(
            bodyText2: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
        //home: MyCustomForm(),
      ),
    );
  }
}
