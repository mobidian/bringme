import 'package:flutter/material.dart';
import 'package:bringme/root_page.dart';
import 'package:bringme/authentification/auth.dart';
import 'package:bringme/user/userProposition.dart';
import 'package:provider/provider.dart';
import 'package:bringme/user/userCourses.dart';
import 'package:bringme/delivery/deliveryCourses.dart';

void main() => runApp(new MyApp());



class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}


class _MyAppState extends State<MyApp>{

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      child: MaterialApp(
          title: 'Bring Me beta 0.1',
          theme: new ThemeData(
            primaryColor: Colors.black,
            accentColor: Colors.blueGrey
          ),
          routes:{
            '/': (BuildContext context) => new RootPage(auth: new Auth()),
            '/userProposition': (BuildContext context) => UserProposition(),
            '/userCourses': (BuildContext context) => UserCourses(),
            '/deliveryCourses': (BuildContext context) => DeliveryCourses(),
          },
      ),
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider<DrawerStateInfo>(
            builder: (_) => DrawerStateInfo()),
      ],
    );

  }
}

class DrawerStateInfo with ChangeNotifier {
  int _currentDrawer = 0;
  int get getCurrentDrawer => _currentDrawer;

  void setCurrentDrawer(int drawer) {
    _currentDrawer = drawer;
    notifyListeners();
  }

  void increment() {
    notifyListeners();
  }
}