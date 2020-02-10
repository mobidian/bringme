import 'package:flutter/material.dart';
import 'package:bringme/main.dart';
import 'package:provider/provider.dart';
import 'package:bringme/services/crud.dart';
import 'package:shimmer/shimmer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bringme/authentification/auth.dart';
import 'deliveryManProfil.dart';

class DrawerDelivery extends StatefulWidget {
  DrawerDelivery(
      {@required this.currentPage,
      this.userId,
      this.logoutCallback,
      this.auth});

  final String currentPage;
  final String userId;
  final VoidCallback logoutCallback;
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() {
    return _DrawerDeliveryState();
  }
}

class _DrawerDeliveryState extends State<DrawerDelivery> {
  CrudMethods crudObj = new CrudMethods();
  Map<String, dynamic> dataMap = {};

  @override
  void initState() {
    super.initState();

    crudObj.getDataFromDeliveryManFromDocument().then((value) {
      setState(() {
        dataMap = value.data;
      });
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
                      builder: (BuildContext context) => DeliveryManProfil()));
            },
          ),
        ),
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
                  : TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0),
            ),
            onTap: () {
              Navigator.of(context).pop();
              if (widget.currentPage == "homeDelivery") return;

              Provider.of<DrawerStateInfo>(context).setCurrentDrawer(0);

              Navigator.pushReplacementNamed(context, "/");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.location_on,
              color: currentDrawer == 1
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            title: Text(
              "Courses",
              style: currentDrawer == 1
                  ? TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)
                  : TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0),
            ),
            onTap: () {
              Navigator.of(context).pop();
              if (widget.currentPage == "deliveryCourses") return;

              Provider.of<DrawerStateInfo>(context).setCurrentDrawer(1);

              Navigator.pushReplacementNamed(context, "/deliveryCourses");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.history,
              color: currentDrawer == 2
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            title: Text(
              "Historique",
              style: currentDrawer == 2
                  ? TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)
                  : TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0),
            ),
            onTap: () {
              Navigator.of(context).pop();
              if (widget.currentPage == "deliveryHistoric") return;

              Provider.of<DrawerStateInfo>(context).setCurrentDrawer(2);

              Navigator.pushReplacementNamed(context, "/deliveryHistoric");
            },
          ),
        ],
      ),
    );
  }
}
