import 'package:flutter/material.dart';
import 'package:bringme/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bringme/root_page.dart';
import 'package:intl/intl.dart';
import 'package:bringme/main.dart';
import 'package:provider/provider.dart';

class PropositionFromDemand extends StatefulWidget {
  PropositionFromDemand(
      {@required this.demandId,
      @required this.listProposition,
      @required this.userId,
      @required this.demandData,
      @required this.title});

  final String demandId;
  final List<dynamic> listProposition;
  final String userId;
  final DocumentSnapshot demandData;
  final String title;

  @override
  State<StatefulWidget> createState() {
    return _PropositionFromDemandState();
  }
}

class _PropositionFromDemandState extends State<PropositionFromDemand> {
  CrudMethods crudObj = new CrudMethods();

  List<dynamic> deliveryManData = [];

  bool _isLoading = false;
  bool _loadingData = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      _loadingData = true;
    });
    for (int i = 0; i < widget.listProposition.length; i++) {
      crudObj
          .getDataFromDeliveryManFromDocumentWithID(
              widget.listProposition[i]['deliveryManId'])
          .then((value) {
        Map<String, dynamic> map = value.data;
        map['deliveryManId'] = widget.listProposition[i]['deliveryManId'];
        map['price'] = widget.listProposition[i]['price'];
        map['suggestTime'] = widget.listProposition[i]['suggestTime'];
        setState(() {
          deliveryManData.add(value.data);
        });
      });
    }
    setState(() {
      _loadingData = false;
    });
  }

  _acceptProposition(deliveryManId, suggestTime, price) async {
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> courseData = {
      'deliveryDate': suggestTime,
      'depart': widget.demandData['depart'],
      'destination': widget.demandData['destination'],
      'retraitDate': widget.demandData['retraitDate'],
      'typeOfMarchandise': widget.demandData['typeOfMarchandise'],
      'typeOfRemorque': widget.demandData['typeOfRemorque'],
      'userId': widget.userId,
      'deliveryManId': deliveryManId,
      'completed': false,
      'price': price,
      'description': widget.demandData['description']
    };

    DocumentReference docRef = await Firestore.instance
        .collection('user')
        .document(widget.userId)
        .collection('course')
        .add(courseData);

    Firestore.instance
        .collection('deliveryman')
        .document(deliveryManId)
        .collection('course')
        .document(docRef.documentID)
        .setData(courseData);

    //faire super gaffe avec ca pcq on peut carrement supprimer toute une collection
    //--------------------------
    Firestore.instance
        .collection('request')
        .document(widget.demandId)
        .delete()
        .catchError((e) {
      print(e.toString());
    });

    Firestore.instance
        .collection('user')
        .document(widget.userId)
        .collection('demand')
        .document(widget.demandId)
        .delete()
        .catchError((e) {
      print(e.toString());
    });

    //--------------------------

    setState(() {
      _isLoading = false;
    });
  }

  _deleteDemand(){
    //faire super gaffe avec ca pcq on peut carrement supprimer toute une collection
    //--------------------------
    Firestore.instance
        .collection('request')
        .document(widget.demandId)
        .delete()
        .catchError((e) {
      print(e.toString());
    });

    Firestore.instance
        .collection('user')
        .document(widget.userId)
        .collection('demand')
        .document(widget.demandId)
        .delete()
        .catchError((e) {
      print(e.toString());
    });

  }

  _showDeleteDemandDialog(){

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: Text("Etes vous sûr ?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Fermer", style: TextStyle(color: Colors.black),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Supprimer", style: TextStyle(color: Colors.red[900]),),
                onPressed: () {
                  _deleteDemand();
                  Provider.of<DrawerStateInfo>(context).setCurrentDrawer(0);
                  Navigator.pushReplacementNamed(context, "/");
                },
              ),
            ],
          );
        });

  }

  @override
  Widget build(BuildContext context) {
    print(deliveryManData);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: _buildListOfProposition(),
            ),
            ButtonTheme(
              child: RaisedButton(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                child: Text("Supprimer la demande",
                    style: TextStyle(color: Colors.red[500], fontSize: 20.0)),
                color: Colors.white,
                onPressed: () {
                  _showDeleteDemandDialog();
                },
              ),
            ),
          ],
        ));
  }

  void _showDialog(deliveryManId, name, price, phone, suggestTime, type, marque) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: Text("Information livreur"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text("Prénom"),
                  subtitle: Text(name),
                ),
                ListTile(
                  title: Text("Téléphone"),
                  subtitle: Text(phone),
                ),
                ListTile(
                  title: Text("Prix proposé"),
                  subtitle: Text(price + "€"),
                ),
                ListTile(
                  title: Text("Type de remorque"),
                  subtitle: Text(type),
                ),
                ListTile(
                  title: Text("Marque du véhicule"),
                  subtitle: Text(marque),
                ),
                ListTile(
                  title: Text("Heure de livraison"),
                  subtitle: Text(DateFormat('HH:mm').format(suggestTime)),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("fermer", style: TextStyle(color: Colors.black),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Accepter", style: TextStyle(color: Colors.green[600]),),
                onPressed: () {
                  _acceptProposition(deliveryManId, suggestTime, price);
                  Provider.of<DrawerStateInfo>(context).setCurrentDrawer(0);
                  Navigator.pushReplacementNamed(context, "/");
                },
              ),
            ],
          );
        });
  }

  _buildListOfProposition() {

    if(deliveryManData.isEmpty){
      return Center(
        child: Text("Aucune proposition pour le moment"),
      );
    }

    if (_loadingData) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        itemCount: widget.listProposition.length,
        itemBuilder: (context, index) {
          String deliveryManName = deliveryManData[index]['name'];
          String price = deliveryManData[index]['price'].toString();
          String phone = deliveryManData[index]['phone'].toString();
          DateTime suggestTime = deliveryManData[index]['suggestTime'].toDate();
          String type = deliveryManData[index]['typeOfRemorque'];
          String marque = deliveryManData[index]['marque'];
          return Container(
            child: ListTile(
              title: Text(deliveryManName),
              subtitle: Text(
                  'heure suggérée ' + DateFormat('HH:mm').format(suggestTime)),
              leading: Text(price + "€"),
              trailing: FlatButton(
                child: Text(
                  "Voir",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  _showDialog(deliveryManData[index]['deliveryManId'],
                      deliveryManName, price, phone, suggestTime,type,marque);
                },
              ),
            ),
          );
        },
      );
    }
  }
}
