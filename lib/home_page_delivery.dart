import 'package:flutter/material.dart';
import 'package:bringme/authentification/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePageDelivery extends StatefulWidget {
  HomePageDelivery({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePageDelivery> {
  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Page DELIVERY"),
        actions: <Widget>[
          FlatButton(
              child: new Text('Logout',
                  style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: signOut)
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('request').snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }
          var data = snapshot.data.documents;
          return pageConstruct(data, context);
        },
      ),
    );
  }


  Widget pageConstruct(data, context){
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index){
        var currentData = data[index];
        return Container(
          child: ListTile(
            title: Text(currentData['typeOfRemorque']),
            subtitle: Text(currentData['destination']),
            trailing: Text(currentData['deliveryTime']),
            onTap: (){},
          ),
        );
      },
    );

  }

}
