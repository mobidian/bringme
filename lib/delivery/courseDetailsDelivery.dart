import 'package:flutter/material.dart';
import 'package:bringme/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetailsDelivery extends StatefulWidget {
  CourseDetailsDelivery(
      {@required this.type, @required this.time, @required this.coursedata});

  final String type;
  final String time;
  final DocumentSnapshot coursedata;

  @override
  State<StatefulWidget> createState() {
    return _CourseDetailsDeliveryState();
  }
}

class _CourseDetailsDeliveryState extends State<CourseDetailsDelivery> {
  CrudMethods crudObj = new CrudMethods();

  Map<String, dynamic> _userId = {};

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      _isLoading = true;
    });
    crudObj
        .getDataFromUserFromDocumentWithID(
        widget.coursedata['userId'])
        .then((value) {
      setState(() {
        _userId = value.data;
      });
      setState(() {
        _isLoading = false;
      });
    });
  }

  _launchURL(phone) async {
    String url = 'tel:' + phone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _deliveryManInfo() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double font = MediaQuery.of(context).textScaleFactor;

    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "Information sur l'utilisateur",
            style: TextStyle(fontSize: font * 20),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                    title: Text("Prénom"),
                    subtitle: Text(_userId['name']),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text("Nom"),
                    subtitle: Text(_userId['surname']),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text("Email"),
                    subtitle: Text(_userId['mail']),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text("Numéro"),
                    subtitle: Text(_userId['phone']),
                    trailing: FlatButton(
                      child: Icon(Icons.phone),
                      onPressed: (){
                        _launchURL(_userId['phone']);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _deliveryInfo() {

    String _typeRemorque = '';

    widget.coursedata['typeOfRemorque'].forEach((k,v){
      if(v == true){
        _typeRemorque += k.toString() + ' ';
      }
    });

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double font = MediaQuery.of(context).textScaleFactor;

    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "Information sur la livraison",
            style: TextStyle(fontSize: font * 20),
          ),
          Card(
            child: ListTile(
              title: Text("Depart"),
              subtitle: Text(widget.coursedata['depart']),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Heure de retrait"),
              subtitle: Text(widget.coursedata['retraitTime']),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Destination"),
              subtitle: Text(widget.coursedata['destination']),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Heure de livraison"),
              subtitle: Text(widget.coursedata['deliveryTime']),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Type de marchandise"),
              subtitle: Text(widget.type),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Type de remorque"),
              subtitle: Text(_typeRemorque),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageConstruct() {
    return ListView(children: <Widget>[
      Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            _deliveryManInfo(),
            Container(
              height: 30.0,
            ),
            _deliveryInfo()
          ],
        ),
      ),
    ]);
  }

  Widget _showCircularProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("A livrer pour " + widget.time),
      ),
      body: _isLoading ? _showCircularProgress() : _pageConstruct(),
    );
  }
}