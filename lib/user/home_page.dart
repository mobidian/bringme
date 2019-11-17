import 'package:flutter/material.dart';
import 'package:bringme/authentification/auth.dart';
import 'package:bringme/services/crud.dart';
import 'package:bringme/services/requestData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bringme/primary_button.dart';
import 'myDrawer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  static final formKey = new GlobalKey<FormState>();
  CrudMethods crudObj = new CrudMethods();

  bool _isLoading = false;

  String _depart;
  String _destination;
  String _retraitTime;
  String _deliveryTime;
  String _typeOfMarchandise;
  String _typeOfRemorque;

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      formKey.currentState.reset();
      setState(() {
        _isLoading = true;
      });

      RequestData requestData = new RequestData(
        depart: _depart,
        destination: _destination,
        retraitTime: _retraitTime,
        deliveryTime: _deliveryTime,
        typeOfMarchandise: _typeOfMarchandise,
        typeOfRemorque: _typeOfRemorque,
        userId: widget.userId,
        completed: false,
        accepted: false,
        proposition: [],
      );

      DocumentReference docRef = await Firestore.instance
          .collection('request')
          .add(requestData.getDataMap());

      Firestore.instance
          .collection('user')
          .document(widget.userId)
          .collection('demand')
          .document(docRef.documentID)
          .setData(requestData.getDataMapForDemand());

      setState(() {
        _isLoading = false;
      });
    } else {
      print("form de demande non valide");
    }
  }

  Widget submitWidget() {
    return PrimaryButton(
      key: new Key('submitrequest'),
      text: 'Poster la demande',
      height: 44.0,
      onPressed: validateAndSubmit,
    );
  }

  Widget _selectDeparture() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 20.0, 10.0, 0.0),
      child: TextFormField(
        key: new Key('selectDepart'),
        decoration: InputDecoration(
          labelText: 'selectionnez l\'adresse de départ',
          icon: new Icon(
            Icons.arrow_forward_ios,
            size: 24,
            color: Theme.of(context).primaryColor,
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Saisissez une adresse';
          }
        },
        onSaved: (value) => _depart = value,
      ),
    );
  }

  Widget _selectDestination() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 20.0, 10.0, 0.0),
      child: TextFormField(
        key: new Key('selectDestination'),
        decoration: InputDecoration(
          labelText: 'selectionnez l\'adresse de destination',
          icon: new Icon(
            Icons.arrow_forward_ios,
            size: 24,
            color: Theme.of(context).primaryColor,
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Saisissez une adresse';
          }
        },
        onSaved: (value) => _destination = value,
      ),
    );
  }

  Widget _selectRetraitTime() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 20.0, 10.0, 0.0),
      child: TextFormField(
        key: new Key('selectRetraitTime'),
        decoration: InputDecoration(
          labelText: 'selectionnez l\'heure de retrait',
          icon: new Icon(
            Icons.arrow_forward_ios,
            size: 24,
            color: Theme.of(context).primaryColor,
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Saisissez une heure';
          }
        },
        onSaved: (value) => _retraitTime = value,
      ),
    );
  }

  Widget _selectDeliveryTime() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 20.0, 10.0, 0.0),
      child: TextFormField(
        key: new Key('selectDeliveryTime'),
        decoration: InputDecoration(
          labelText: 'selectionnez l\'heure de livraison',
          icon: new Icon(
            Icons.arrow_forward_ios,
            size: 24,
            color: Theme.of(context).primaryColor,
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Saisissez une heure';
          }
        },
        onSaved: (value) => _deliveryTime = value,
      ),
    );
  }

  Widget _selectTypeOfMarchandise() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 20.0, 10.0, 0.0),
      child: TextFormField(
        key: new Key('selectTypeOfMarchandise'),
        decoration: InputDecoration(
          labelText: 'selectionnez le type de marchandise',
          icon: new Icon(
            Icons.arrow_forward_ios,
            size: 24,
            color: Theme.of(context).primaryColor,
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Saisissez un type de marchandise';
          }
        },
        onSaved: (value) => _typeOfMarchandise = value,
      ),
    );
  }

  Widget _selectTypeOfRemorque() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 20.0, 10.0, 0.0),
      child: TextFormField(
        key: new Key('selectTypeOfRemorque'),
        decoration: InputDecoration(
          labelText: 'selectionnez un type de remorque',
          icon: new Icon(
            Icons.arrow_forward_ios,
            size: 24,
            color: Theme.of(context).primaryColor,
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Saisissez un type de remorque';
          }
        },
        onSaved: (value) => _typeOfRemorque = value,
      ),
    );
  }

  Widget _showCircularProgress() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                _selectDeparture(),
                _selectDestination(),
                _selectRetraitTime(),
                _selectDeliveryTime(),
                _selectTypeOfMarchandise(),
                _selectTypeOfRemorque(),
              ],
            ),
          ),
          _isLoading == false ? submitWidget() : _showCircularProgress(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("USER page"),
        actions: <Widget>[
          FlatButton(
              child: new Text('Logout',
                  style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: signOut)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: <Widget>[
            Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text(widget.userId),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: buildForm(),
              ),
            ]),
          ]),
        ),
      ),
      drawer:  MyDrawer(currentPage: "home", userId: widget.userId,),
    );
  }
}
