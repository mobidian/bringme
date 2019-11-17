import 'package:flutter/material.dart';
import 'package:bringme/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PropositionFromDemand extends StatefulWidget {
  PropositionFromDemand(
      {@required this.demandId,
      @required this.listProposition,
      @required this.userId,
      @required this.demandData});

  final String demandId;
  final List<dynamic> listProposition;
  final String userId;
  final DocumentSnapshot demandData;

  @override
  State<StatefulWidget> createState() {
    return _PropositionFromDemandState();
  }
}

class _PropositionFromDemandState extends State<PropositionFromDemand> {
  CrudMethods crudObj = new CrudMethods();
  bool _isLoading = false;

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
    return Scaffold(
        appBar: AppBar(
          title: Text("propositionfromdemand"),
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

  _buildListOfProposition() {
    //pour le moment seul l'id du livreur est montré mais l'idéal
    //serait d'avoir ses infos à montrer
    //sur la meme page parce que sinon beaucoup trop de page dans des pages
    //c'est lourd et chiant à naviguer
    return ListView.builder(
      itemCount: widget.listProposition.length,
      itemBuilder: (context, index) {
        String deliveryManId = widget.listProposition[index]['deliveryManId'];
        return Container(
          child: ListTile(
            title: Text(deliveryManId),
            subtitle: Text(widget.listProposition[index]['price'].toString()),
            trailing: FlatButton(
              child: Icon(Icons.check_circle_outline),
              onPressed: () {
                _acceptProposition(deliveryManId);
              },
            ),
          ),
        );
      },
    );
  }
}
