import 'package:flutter/material.dart';
import 'package:bringme/authentification/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bringme/services/crud.dart';
import 'package:bringme/delivery/drawerDelivery.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'deliveryCourses.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  final _formKey = new GlobalKey<FormState>();
  CrudMethods crudObj = new CrudMethods();

  int _price;
  String _suggestTime;


  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }


  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }


  Widget _buildPriceField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        key: new Key('price'),
        decoration: InputDecoration(
          labelText: 'Prix',
          icon: new Icon(
            Icons.euro_symbol,
            color: Colors.grey,
          ),
        ),
        keyboardType: TextInputType.number,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Saisissez un prix';
          }
          return null;
        },
        onSaved: (value) => _price = int.parse(value.trim()),
      ),
    );
  }

  Widget _buildSuggestTimeField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        key: new Key('suggestTime'),
        decoration: InputDecoration(
          labelText: 'Heure Suggérée',
          icon: new Icon(
            Icons.timer,
            color: Colors.grey,
          ),
        ),
// a terme changer par un textinput number car il s'agira d'une heure ou alors fait un calendrier de selection
//        keyboardType: TextInputType.number,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Saisissez une heure';
          }
          return null;
        },
        onSaved: (value) => _suggestTime = value.trim(),
      ),
    );
  }

  void sendProposition(userId, requestId) {
    print(userId);
    print(requestId);


    if(validateAndSave()) {
      crudObj.getDataFromUserDemand(userId, requestId).then((value) {
        Map<String, dynamic> dataMap = value.data;
        List<dynamic> listProposition = dataMap['proposition'];
//      print(listProposition);
        List propositionTemp = List.from(listProposition);
        propositionTemp.add({
          "deliveryManId": widget.userId,
          "price": _price,
          "suggestHour": _suggestTime
        });

        Map<String, dynamic> updatedProposition = {
          'proposition': propositionTemp
        };
        crudObj.updateDemandData(userId, requestId, updatedProposition);
      });
    }else{
      print("le form n'est pas valide");
    }

//    Firestore.instance
//        .collection('user')
//        .document(userId)
//        .collection('demand')
//        .document(requestId)
//        .setData(requestData.getDataMapForDemand(),merge: true);
//
  }



  void _showDialog(userId, requestId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Accepter la livraison"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _buildPriceField(),
                      _buildSuggestTimeField()
                    ],
                  ),
                ),
              ],

            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Fermer"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Envoyer"),
                onPressed: (){
                  sendProposition(userId, requestId);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => DeliveryCourses()
                      ));
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double font = MediaQuery.of(context).textScaleFactor;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Accueil livreur"),
        actions: <Widget>[
          FlatButton(
              child: Icon(
                FontAwesomeIcons.signOutAlt,
                color: Colors.white,
              ),
              onPressed: signOut)
        ],
      ),
      drawer: DrawerDelivery(
        currentPage: 'homeDelivery',
        userId: widget.userId,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Demandes actuelles",
              style: TextStyle(fontSize: font * 17),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: Firestore.instance.collection('request').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                var data = snapshot.data.documents;
                return pageConstruct(data, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget pageConstruct(data, context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        var currentData = data[index];
        var requestId = data[index].documentID;
        return Container(
          child: ListTile(
            title: Text(currentData['destination'] + ' à ' + currentData['deliveryTime']),
            subtitle: Text(currentData['typeOfRemorque']),
            trailing: FlatButton(
              child: Icon(FontAwesomeIcons.arrowRight, color: Colors.green,),
              onPressed: () {
                _showDialog(currentData['userId'], requestId);
              },
            ),
          ),
        );
      },
    );
  }
}
