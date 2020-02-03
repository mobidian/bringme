import 'package:flutter/material.dart';
import 'package:bringme/authentification/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bringme/services/crud.dart';
import 'package:bringme/delivery/drawerDelivery.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  final _formKey = new GlobalKey<FormState>();
  CrudMethods crudObj = new CrudMethods();

  int _price;
  DateTime _suggestTime = DateTime.now();

  //notification
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((token){
      print(token);
      crudObj.createOrUpdateDeliveryManData({"tokenNotif": token});
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        print(notification);
        print(notification['title']);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
    );

    //juste pour IOS
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

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

  final DateFormat dateFormat = DateFormat('HH:mm');

  Widget _buildSuggestTimeField(context, currentData) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Heure sugérée'),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Text(
              dateFormat.format(_suggestTime),
              style: TextStyle(color: Colors.grey[700]),
            ),
            onPressed: () async {
              final selectedTime = await _selectTime(context);
              if (selectedTime == null) return;

              setState(() {
                this._suggestTime = DateTime(
                  currentData["deliveryDate"].toDate().year,
                  currentData["deliveryDate"].toDate().month,
                  currentData["deliveryDate"].toDate().day,
                  selectedTime.hour,
                  selectedTime.minute,
                );
              });
              print(_suggestTime);
            },
          ),
        ],
      ),
    );
  }

  Future<TimeOfDay> _selectTime(BuildContext context) {
    return showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: _suggestTime.hour, minute: _suggestTime.minute),
    );
  }

  void sendProposition(userId, requestId) {
    print(userId);
    print(requestId);

    if (validateAndSave()) {
      crudObj.getDataFromUserDemand(userId, requestId).then((value) {
        Map<String, dynamic> dataMap = value.data;
        List<dynamic> listProposition = dataMap['proposition'];
//      print(listProposition);
        List propositionTemp = List.from(listProposition);
        propositionTemp.add({
          "deliveryManId": widget.userId,
          "price": _price,
          "suggestTime": _suggestTime
        });

        Map<String, dynamic> updatedProposition = {
          'proposition': propositionTemp
        };
        crudObj.updateDemandData(userId, requestId, updatedProposition);
      });
    } else {
      print("le form n'est pas valide");
    }
  }

  Widget _buildRequestInfo(currentData, remorque) {
    String typeMarchandise = '';
    currentData['typeOfMarchandise'].forEach((k, v) {
      if (v == true) {
        typeMarchandise += ' ' + k.toString();
      }
    });

    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Départ"),
              subtitle: Text(currentData['depart'] +
                  ' à ' +
                  DateFormat('HH:mm')
                      .format(currentData['retraitDate'].toDate()) +
                  ' le ' +
                  DateFormat('dd/MM/yy')
                      .format(currentData['retraitDate'].toDate())),
            ),
            ListTile(
              title: Text("Destination"),
              subtitle: Text(currentData['destination'] +
                  ' à ' +
                  DateFormat('HH:mm')
                      .format(currentData['deliveryDate'].toDate()) +
                  ' le ' +
                  DateFormat('dd/MM/yy')
                      .format(currentData['deliveryDate'].toDate())),
            ),
            ListTile(
              title: Text('Marchandise'),
              subtitle: Text(typeMarchandise),
            ),
            ListTile(
              title: Text('Remorque'),
              subtitle: Text(remorque),
            ),
          ],
        ));
  }

  void _showDialog(userId, requestId, currentData, remorque) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: Text("Accepter la livraison"),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _buildRequestInfo(currentData, remorque),
                      Form(
                        key: _formKey,
                        child: _buildPriceField(),
                      ),
                      _buildSuggestTimeField(context, currentData)
                    ],
                  ),
                );
              },
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
                onPressed: () {
                  sendProposition(userId, requestId);
                  Navigator.pop(context);
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
      ),
      drawer: DrawerDelivery(
        currentPage: 'homeDelivery',
        userId: widget.userId,
        auth: widget.auth,
        logoutCallback: widget.logoutCallback,
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
        String remorque = '';
        currentData['typeOfRemorque'].forEach((k, v) {
          if (v == true) {
            remorque += ' ' + k.toString();
          }
        });
        var requestId = data[index].documentID;
        return Column(
          children: <Widget>[
            Container(
              child: ListTile(
                title: Text(currentData['depart'] +
                    ' à ' +
                    DateFormat('HH:mm')
                        .format(currentData['retraitDate'].toDate()) +
                    ' le ' +
                    DateFormat('dd/MM/yy')
                        .format(currentData['retraitDate'].toDate())),
                subtitle: Text(remorque),
                trailing: FlatButton(
                  child: Icon(
                    FontAwesomeIcons.arrowRight,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    setState(() {
                      _suggestTime = currentData['deliveryDate'].toDate();
                    });
                    _showDialog(currentData['userId'], requestId, currentData,
                        remorque);
                  },
                ),
              ),
            ),
            Divider()
          ],
        );
      },
    );
  }
}
