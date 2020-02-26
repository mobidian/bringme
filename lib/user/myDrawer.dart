import 'package:flutter/material.dart';
import 'package:bringme/main.dart';
import 'package:provider/provider.dart';
import 'package:bringme/services/crud.dart';
import 'package:shimmer/shimmer.dart';
import 'package:bringme/user/home_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bringme/authentification/auth.dart';
import 'userProfil.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer(
      {@required this.currentPage,
      @required this.userId,
      this.logoutCallback,
      this.auth});

  final String currentPage;
  final String userId;
  final VoidCallback logoutCallback;
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() {
    return _MyDrawerState();
  }
}

class _MyDrawerState extends State<MyDrawer> {
  CrudMethods crudObj = new CrudMethods();
  Map<String, dynamic> dataMap = {};
  int _numberOfPropositions = 0;

  final BaseAuth auth = new Auth();

  @override
  void initState() {
    super.initState();

    crudObj.getDataFromUserFromDocument().then((value) {
      setState(() {
        dataMap = value.data;
      });
    });

    crudObj.getAllDemandFromUser(widget.userId).then((value) {
      var docs = value.documents;
      for (int i = 0; i < docs.length; i++) {
        var demandId = docs[i].documentID;
        crudObj.getDataFromUserDemand(widget.userId, demandId).then((doc) {
          var data = doc.data;
          setState(() {
            _numberOfPropositions += data['proposition'].length;
          });
        });
      }
    });
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  Widget _showShimmerLoading() {
    return Container(
        padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 10.0),
//        width: 200.0,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
//              // photo de profil
                  backgroundColor: Colors.black54,
                  minRadius: 25,
                  maxRadius: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: 40.0,
                        height: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _headerContent() {
    var currentDrawer = Provider.of<DrawerStateInfo>(context).getCurrentDrawer;

    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            // photo de profil
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(dataMap['picture']),
            minRadius: 25,
            maxRadius: 25,
          ),
          title: Text(
            "Bonjour",
            style: TextStyle(fontSize: 20.0),
          ),
          subtitle: Text(
            dataMap["name"],
            style: TextStyle(fontSize: 15.0),
          ),
        ),
        ListTile(
            title: Text(dataMap["mail"]),
            trailing: IconButton(
              icon: Icon(
                FontAwesomeIcons.userCircle,
                size: 20.0,
                color: Colors.black,
              ),
              onPressed: () {
                Provider.of<DrawerStateInfo>(context).setCurrentDrawer(10);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => UserProfil()));
              },
            )),
      ],
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: dataMap.isEmpty ? _showShimmerLoading() : _headerContent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentDrawer = Provider.of<DrawerStateInfo>(context).getCurrentDrawer;
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                _createHeader(),
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: currentDrawer == 0
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  title: Text(
                    "Accueil",
                    style: currentDrawer == 0
                        ? TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)
                        : TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (widget.currentPage == "welcome") return;

                    Provider.of<DrawerStateInfo>(context).setCurrentDrawer(0);

                    Navigator.pushReplacementNamed(context, "/");
                  },
                ),
                ListTile(
                  leading: Icon(
                    FontAwesomeIcons.truckLoading,
                    color: currentDrawer == 1
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  title: Text(
                    "Réserver",
                    style: currentDrawer == 1
                        ? TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)
                        : TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (widget.currentPage == "reserver") return;

                    Provider.of<DrawerStateInfo>(context).setCurrentDrawer(1);

//              Navigator.pushReplacementNamed(context, "/userProposition");
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => HomePage(
                                  userId: widget.userId,
                                )));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.assignment_turned_in,
                    color: currentDrawer == 2
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  title: Text(
                    "Propositions",
                    style: currentDrawer == 2
                        ? TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)
                        : TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18.0),
                  ),
                  trailing: _numberOfPropositions == 0
                      ? Text("")
                      : Text(_numberOfPropositions.toString(),
                          style: TextStyle(
                              color: Colors.green[600],
                              fontWeight: FontWeight.w800)),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (widget.currentPage == "proposition") return;

                    Provider.of<DrawerStateInfo>(context).setCurrentDrawer(2);

                    Navigator.pushReplacementNamed(context, "/userProposition");
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: currentDrawer == 3
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  title: Text(
                    "Courses",
                    style: currentDrawer == 3
                        ? TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)
                        : TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (widget.currentPage == "courses") return;

                    Provider.of<DrawerStateInfo>(context).setCurrentDrawer(3);

                    Navigator.pushReplacementNamed(context, "/userCourses");
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.history,
                    color: currentDrawer == 4
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  title: Text(
                    "Historique",
                    style: currentDrawer == 4
                        ? TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)
                        : TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (widget.currentPage == "userHistoric") return;

                    Provider.of<DrawerStateInfo>(context).setCurrentDrawer(4);

                    Navigator.pushReplacementNamed(context, "/userHistoric");
                  },
                ),
              ],
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                children: <Widget>[
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: currentDrawer == 5
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    title: Text(
                      "A Propos",
                      style: currentDrawer == 5
                          ? TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0)
                          : TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 18.0),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      if (widget.currentPage == "aProposUser") return;

                      Provider.of<DrawerStateInfo>(context).setCurrentDrawer(5);

                      Navigator.pushReplacementNamed(context, "/aProposUser");
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
