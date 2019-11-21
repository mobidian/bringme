import 'package:flutter/material.dart';
import 'package:bringme/authentification/auth.dart';
import 'package:bringme/services/crud.dart';
import 'package:bringme/services/requestData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bringme/primary_button.dart';
import 'myDrawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'typeOfRemorqueCheckbox.dart';

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

  //type de remorque
  Map<String, dynamic> mapRemorque = {
    'vcc': false,
    'vbb' : false,
    'u3': false,
    'u6': false,
    'u9' : false,
    'u12': false,
    'u14' : false,
    'u20' : false,
    'u20pc' : false,
    'vif' : false
  };

  //type de marchandise
  Map<String, dynamic> mapMarchandise = {
    'fragile' : false,
    'leger' : false,
    'lourd' : false,
    'dangereux' : false,
  };



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
        typeOfMarchandise: mapMarchandise,
        typeOfRemorque: mapRemorque,
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

//  Widget _selectTypeOfMarchandise() {
//    return Padding(
//      padding: const EdgeInsets.fromLTRB(5.0, 20.0, 10.0, 0.0),
//      child: TextFormField(
//        key: new Key('selectTypeOfMarchandise'),
//        decoration: InputDecoration(
//          labelText: 'selectionnez le type de marchandise',
//          icon: new Icon(
//            Icons.arrow_forward_ios,
//            size: 24,
//            color: Theme.of(context).primaryColor,
//          ),
//        ),
//        validator: (String value) {
//          if (value.isEmpty) {
//            return 'Saisissez un type de marchandise';
//          }
//        },
//        onSaved: (value) => _typeOfMarchandise = value,
//      ),
//    );
//  }

  Widget _showSelectTypeOfMarchandise() {
    return IconButton(
      icon: Icon(Icons.arrow_forward),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: mapMarchandise['fragile'],
                            onChanged: (bool value) {
                              setState(() {
                                mapMarchandise['fragile'] = value;
                              });
                            },
                          ),
                          Text("Fragile"),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: mapMarchandise['leger'],
                            onChanged: (bool value) {
                              setState(() {
                                mapMarchandise['leger'] = value;
                              });
                            },
                          ),
                          Text("Léger"),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: mapMarchandise['lourd'],
                            onChanged: (bool value) {
                              setState(() {
                                mapMarchandise['lourd'] = value;
                              });
                            },
                          ),
                          Text("Lourd"),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: mapMarchandise['dangereux'],
                            onChanged: (bool value) {
                              setState(() {
                                mapMarchandise['dangereux'] = value;
                              });
                            },
                          ),
                          Text("Dangereux"),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          color: Theme.of(context).accentColor,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                          child: Text("Ok", style: TextStyle(color: Colors.white),),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  );
                }),
              );
            });
      },
    );
  }

  Widget _showSelectTypeOfRemorque() {
    return IconButton(
      icon: Icon(Icons.arrow_forward),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: mapRemorque['vcc'],
                              onChanged: (bool value) {
                                setState(() {
                                  mapRemorque['vcc'] = value;
                                });
                              },
                            ),
                            Flexible(
                              child: Container(
                                child: Text(
                                  "Voiture citadine & compact",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: mapRemorque['vbb'],
                              onChanged: (bool value) {
                                setState(() {
                                  mapRemorque['vbb'] = value;
                                });
                              },
                            ),
                            Flexible(
                              child: Container(
                                child: Text(
                                  "Voiture berline & break",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: mapRemorque['u3'],
                              onChanged: (bool value) {
                                setState(() {
                                  mapRemorque['u3'] = value;
                                });
                              },
                            ),
                            Flexible(
                              child: Container(
                                child: Text(
                                  "Utilitaire 3 m3",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: mapRemorque['u6'],
                              onChanged: (bool value) {
                                setState(() {
                                  mapRemorque['u6'] = value;
                                });
                              },
                            ),
                            Flexible(
                              child: Container(
                                child: Text(
                                  "Utilitaire 6 m3",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: mapRemorque['u9'],
                              onChanged: (bool value) {
                                setState(() {
                                  mapRemorque['u9'] = value;
                                });
                              },
                            ),
                            Flexible(
                              child: Container(
                                child: Text(
                                  "Utilitaire 9 m3",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: mapRemorque['u12'],
                              onChanged: (bool value) {
                                setState(() {
                                  mapRemorque['u12'] = value;
                                });
                              },
                            ),
                            Flexible(
                              child: Container(
                                child: Text(
                                  "Utilitaire 12 m3",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: mapRemorque['u14'],
                              onChanged: (bool value) {
                                setState(() {
                                  mapRemorque['u14'] = value;
                                });
                              },
                            ),
                            Flexible(
                              child: Container(
                                child: Text(
                                  "Utilitaire 14 m3",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: mapRemorque['u20'],
                              onChanged: (bool value) {
                                setState(() {
                                  mapRemorque['u20'] = value;
                                });
                              },
                            ),
                            Flexible(
                              child: Container(
                                child: Text(
                                  "Utilitaire 20 m3",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: mapRemorque['u20pc'],
                              onChanged: (bool value) {
                                setState(() {
                                  mapRemorque['u20pc'] = value;
                                });
                              },
                            ),
                            Flexible(
                              child: Container(
                                child: Text(
                                  "Utilitaire 20 m3 avec plateau de chargement",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: mapRemorque['vif'],
                              onChanged: (bool value) {
                                setState(() {
                                  mapRemorque['vif'] = value;
                                });
                              },
                            ),
                            Flexible(
                              child: Container(
                                child: Text(
                                  "Véhicule isotherme ou frigorifique",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                            child: Text("Ok", style: TextStyle(color: Colors.white),),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        )
                      ],
                    );
                  },
                ),
              );
            });
      },
    );
  }


  Widget _showTypeOfMarchandise(){
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("selectionnez le type de marchandise"),
              _showSelectTypeOfMarchandise(),
            ],
          ),
        ],
      ),
    );
  }


  Widget _showTypeOfRemorque(){
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('Selectionnez le type de remorque'),
              _showSelectTypeOfRemorque(),
            ],
          ),
        ],
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
                _showTypeOfMarchandise(),
                _showTypeOfRemorque(),
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double font = MediaQuery.of(context).textScaleFactor;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Accueil"),
        actions: <Widget>[
          FlatButton(
              child: Icon(
                FontAwesomeIcons.signOutAlt,
                color: Colors.white,
              ),
              onPressed: signOut)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: <Widget>[
            Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text(
                "Faire une demande de livraison",
                style: TextStyle(fontSize: font * 15),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: buildForm(),
              ),
            ]),
          ]),
        ),
      ),
      drawer: MyDrawer(
        currentPage: "home",
        userId: widget.userId,
      ),
    );
  }
}
