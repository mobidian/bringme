import 'package:flutter/material.dart';
import 'package:bringme/authentification/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bringme/services/crud.dart';


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

  CrudMethods crudObj = new CrudMethods();

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }


  void sendProposition(userId, requestId){
    print(userId);
    print(requestId);

    crudObj.getDataFromUserDemand(userId, requestId).then((value){
      Map<String, dynamic> dataMap = value.data;
      List<dynamic> listProposition = dataMap['proposition'];
//      print(listProposition);
      List propositionTemp = List.from(listProposition);
      propositionTemp.add({
        "deliveryManId": widget.userId,
        "price": 10,
      });

      Map<String, dynamic> updatedProposition = {
        'proposition': propositionTemp
      };
      crudObj.updateDemandData(userId, requestId, updatedProposition);
    });

//    Firestore.instance
//        .collection('user')
//        .document(userId)
//        .collection('demand')
//        .document(requestId)
//        .setData(requestData.getDataMapForDemand(),merge: true);
//
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
        var requestId = data[index].documentID;
        return Container(
          child: ListTile(
            title: Text(currentData['typeOfRemorque']),
            subtitle: Text(currentData['destination']),
            trailing: FlatButton(
              child: Icon(Icons.check),
              onPressed: (){
                sendProposition(currentData['userId'], requestId);
              },
            ),
          ),
        );
      },
    );

  }

}
