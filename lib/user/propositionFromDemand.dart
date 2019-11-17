import 'package:flutter/material.dart';
import 'package:bringme/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  void initState(){
    super.initState();

    setState(() {
      _loadingData = true;
    });
    for(int i = 0; i < widget.listProposition.length; i++){
      crudObj.getDataFromDeliveryManFromDocumentWithID(widget.listProposition[i]['deliveryManId']).then((value){
        Map<String, dynamic> map = value.data;
        map['deliveryManId'] = widget.listProposition[i]['deliveryManId'];
        map['price'] = widget.listProposition[i]['price'];
        setState(() {
          deliveryManData.add(value.data);
        });
      });
    }
    setState(() {
      _loadingData = false;
    });

  }


  _acceptProposition(deliveryManId) async {
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> courseData = {
      'deliveryTime': widget.demandData['deliveryTime'],
      'depart': widget.demandData['depart'],
      'destination': widget.demandData['destination'],
      'retraitTime': widget.demandData['retraitTime'],
      'typeOfMarchandise': widget.demandData['typeOfMarchandise'],
      'typeOfRemorque': widget.demandData['typeOfRemorque'],
      'userId': widget.userId,
      'deliveryManId': deliveryManId,
      'completed': false,
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

  @override
  Widget build(BuildContext context) {
    print(deliveryManData);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Text(widget.demandId),
            Expanded(
              child: _buildListOfProposition(),
            ),
          ],
        ));
  }


  void _showDialog(deliveryManId, name, price, phone){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Information livreur"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Prénom : " + name),
              Text("Téléphone : " + phone),
              Text("Prix proposé : " + price),
              Text("Heure de livraison : - à ajouter -"),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("fermer"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),

            FlatButton(
              child: Text("Accepter"),
              onPressed: (){
                _acceptProposition(deliveryManId);

              },
            ),
          ],
        );
      }
    );
  }

  _buildListOfProposition() {
    //pour le moment seul l'id du livreur est montré mais l'idéal
    //serait d'avoir ses infos à montrer
    //sur la meme page parce que sinon beaucoup trop de page dans des pages
    //c'est lourd et chiant à naviguer

    if(_loadingData || deliveryManData.isEmpty){
      return CircularProgressIndicator();
    }else {
      return ListView.builder(
        itemCount: widget.listProposition.length,
        itemBuilder: (context, index) {
          String deliveryManName = deliveryManData[index]['name'];
          String price = deliveryManData[index]['price'].toString();
          String phone = deliveryManData[index]['phone'].toString();
          return Container(
            child: ListTile(
              title: Text(deliveryManName),
              subtitle: Text(price),
              trailing: FlatButton(
                child: Icon(Icons.check_circle_outline),
                onPressed: () {
                  _showDialog(deliveryManData[index]['deliveryManId'], deliveryManName, price, phone);
                },
              ),
            ),
          );
        },
      );
    }
  }
}
