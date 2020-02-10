import 'package:flutter/material.dart';
import 'package:bringme/authentification/auth.dart';
import 'package:bringme/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'selectProfilPictureDelivery.dart';
import 'drawerDelivery.dart';

class DeliveryManProfil extends StatefulWidget {
  DeliveryManProfil({this.onSignOut});

  final VoidCallback onSignOut;

  final BaseAuth auth = new Auth();

  void _signOut() async {
    try {
      await auth.signOut();
      onSignOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _DeliveryManProfilState();
  }
}

class _DeliveryManProfilState extends State<DeliveryManProfil> {
  String userId = 'userId';
  CrudMethods crudObj = new CrudMethods();
  String userMail = 'userMail';

  String _phoneNumber;
  String _name;
  String _surname;

  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    widget.auth.currentUserId().then((id) {
      setState(() {
        userId = id;
      });
    });
    widget.auth.userEmail().then((mail) {
      setState(() {
        userMail = mail;
      });
    });

    crudObj.getDataFromDeliveryManFromDocument().then((value) {
      Map<String, dynamic> dataMap = value.data;
    });
  }

  void _openModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF737373)),
              color: Color(0xFF737373),
            ),
            child: Container(
              child: SelectProfilPictureDelivery(),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(25.0),
                  topRight: const Radius.circular(25.0),
                ),
              ),
            ),
          );
        });
  }

  String validateEmail(String value) {
    if (value.isEmpty ||
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return 'Saisissez un e-mail valide';
    } else
      return null;
  }

  String validatePhone(String value) {
    if (value.length != 10)
      return 'Veuillez entrer un numéro valide';
    else
      return null;
  }

  String validateNames(String value) {
    if (value.length < 1)
      return 'Ce champ ne doit pas être vide !';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('deliveryman')
          .document(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        var userData = snapshot.data;
        return pageConstruct(userData, context);
      },
    );
  }

  Widget userInfoTopSection(userData) {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color.fromRGBO(0, 0, 0, 1),
                width: 6,
              ),
            ),
            child: GestureDetector(
              onTap: () {
                _openModalBottomSheet(context);
              },
              child: CircleAvatar(
                // photo de profil
                backgroundImage: NetworkImage(userData['picture']),
                minRadius: 30,
                maxRadius: 93,
              ),
            ),
          ),
          Container(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Divider(
      color: Colors.black,
      height: 15,
      indent: 70,
    );
  }

  Widget userBottomSection(userData) {
    Widget name() {
      return ListTile(
        leading: Icon(
          Icons.person,
          color: Colors.black,
          size: 35,
        ),
        title: Text(
          "Prénom",
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: Colors.black),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              validator: validateNames,
                              decoration:
                                  InputDecoration(hintText: userData['name']),
                              onSaved: (value) => _name = value,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              color: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              child: Text(
                                "Valider",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  crudObj.createOrUpdateDeliveryManData(
                                      {'name': _name});
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
        subtitle: Text(
          userData['name'],
          style: TextStyle(
            fontSize: 15.0,
            color: Theme.of(context).accentColor,
          ),
        ),
      );
    }

    Widget surname() {
      return ListTile(
        leading: Icon(
          Icons.supervisor_account,
          color: Colors.black,
          size: 35,
        ),
        title: Text(
          "Nom",
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: Colors.black),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              validator: validateNames,
                              decoration: InputDecoration(
                                  hintText: userData['surname']),
                              onSaved: (value) => _surname = value,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              color: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              child: Text(
                                "Valider",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  crudObj.createOrUpdateDeliveryManData(
                                      {'surname': _surname});
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
        subtitle: Text(
          userData['surname'],
          style:
              TextStyle(fontSize: 15.0, color: Theme.of(context).accentColor),
        ),
      );
    }

    Widget mail() {
      return ListTile(
        leading: Icon(
          Icons.mail,
          color: Colors.black,
          size: 35,
        ),
        title: Text(
          'Mail',
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        subtitle: Text(
          userMail,
          style:
              TextStyle(fontSize: 15.0, color: Theme.of(context).accentColor),
        ),
      );
    }

    Widget phone() {
      return ListTile(
        leading: Icon(
          Icons.phone,
          color: Colors.black,
          size: 35,
        ),
        title: Text(
          "Numéro",
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: Colors.black),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              validator: validatePhone,
                              decoration: InputDecoration(
                                  hintText: 'Numéro de téléphone'),
                              keyboardType: TextInputType.number,
                              onSaved: (value) => _phoneNumber = value,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              color: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              child: Text(
                                "Valider",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  crudObj.createOrUpdateDeliveryManData(
                                      {'phone': _phoneNumber});
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
        subtitle: Text(
          userData['phone'],
          style:
              TextStyle(fontSize: 15.0, color: Theme.of(context).accentColor),
        ),
      );
    }

    Widget immatriculation() {
      return ListTile(
        leading: Icon(
          Icons.assignment,
          color: Colors.black,
          size: 35,
        ),
        title: Text(
          'Immatriculation',
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        subtitle: Text(
          userData['immatriculation'],
          style:
              TextStyle(fontSize: 15.0, color: Theme.of(context).accentColor),
        ),
      );
    }

    Widget remorque() {
      return ListTile(
        leading: Icon(
          Icons.airport_shuttle,
          color: Colors.black,
          size: 35,
        ),
        title: Text(
          'Remorque',
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        subtitle: Text(
          userData['typeOfRemorque'],
          style:
              TextStyle(fontSize: 15.0, color: Theme.of(context).accentColor),
        ),
      );
    }

    Widget marque() {
      return ListTile(
        leading: Icon(
          Icons.branding_watermark,
          color: Colors.black,
          size: 35,
        ),
        title: Text(
          'Marque du véhicule',
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        subtitle: Text(
          userData['marque'],
          style:
              TextStyle(fontSize: 15.0, color: Theme.of(context).accentColor),
        ),
      );
    }

//    Widget notification() {
//      return ListTile(
//        leading: Icon(
//          Icons.notifications,
//          color: Colors.white,
//          size: 35,
//        ),
//        title: Text(
//          "Notification",
//          style: TextStyle(color: Colors.white, fontSize: 18.0),
//        ),
//        trailing: Switch(
//          value: _notificationValue, onChanged: _onChangedNotification,activeColor: Colors.lightBlueAccent,),
//      );
//    }

    return Padding(
      padding: EdgeInsets.only(top: 5.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: FractionalOffset.center,
                    width: 390,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 16),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Column(
                                  children: <Widget>[
                                    name(),
                                    divider(),
                                    surname(),
                                    divider(),
                                    mail(),
                                    divider(),
                                    phone(),
                                    divider(),
                                    immatriculation(),
                                    divider(),
                                    remorque(),
                                    divider(),
                                    marque(),
                                    divider(),
//                                    notification(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget pageConstruct(userData, context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: DrawerDelivery(
        currentPage: 'deliveryProfil',
        userId: userId,
      ),
      resizeToAvoidBottomPadding: false,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: userData['name'] == ""
                  ? Text(userMail)
                  : Text(
                      userData['name'] + ' ' + userData['surname'],
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  child: userInfoTopSection(userData),
                ),
                Container(
                  child: userBottomSection(userData),
                ),
                Container(
                  height: 10,
                ),
                Container(
                  child: FlatButton(
                      onPressed: () {
                        widget._signOut();
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: Text(
                        "Deconnexion",
                        style: TextStyle(
                          color: Colors.red[300],
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
