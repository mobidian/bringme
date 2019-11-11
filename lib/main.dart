import 'package:flutter/material.dart';
import 'package:bringme/root_page.dart';
import 'package:bringme/authentification/auth.dart';
import 'userProposition.dart';
import 'package:provider/provider.dart';

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