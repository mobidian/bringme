import 'package:flutter/material.dart';
import 'package:bringme/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'home_page.dart';
import 'dart:math';

class RateDelivery extends StatefulWidget {
  RateDelivery({@required this.courseData});

  final DocumentSnapshot courseData;

  @override
  State<StatefulWidget> createState() {
    return _RateDeliveryState();
  }
}

class _RateDeliveryState extends State<RateDelivery> {
  CrudMethods crudObj = new CrudMethods();

  Map<String, dynamic> deliveryManData;

  var note;

  @override
  void initState() {
    super.initState();
    crudObj
        .getDataFromDeliveryManFromDocumentWithID(
            widget.courseData['deliveryManId'])
        .then((value) {
      setState(() {
        deliveryManData = value.data;
      });
    });
  }

  double roundDouble(double value, int places){
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  void sendRating() {

    if (deliveryManData['star'] == null || deliveryManData['totalRate'] == null) {
      crudObj.updateDeliveryManDataWithID(
          widget.courseData['deliveryManId'], {'star': note, 'totalRate': 1});
    } else {

      var totalPoint = deliveryManData['star'] * deliveryManData['totalRate'];
      var newTotalRate = deliveryManData['totalRate'] + 1;
      var newStar = (totalPoint + note) / newTotalRate;

      var roundedNewStar = roundDouble(newStar, 1);

      print(totalPoint);
      print(newStar);

      crudObj.updateDeliveryManDataWithID(widget.courseData['deliveryManId'],
          {'star': roundedNewStar, 'totalRate': newTotalRate});
    }

    Provider.of<DrawerStateInfo>(context).setCurrentDrawer(1);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => HomePage(
          userId: widget.courseData['userId'],
        ),
      ),
    );
  }

  Widget ratingSystem() {
    if (deliveryManData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
        child: Column(
      children: <Widget>[
        RatingBar(
          initialRating: 0,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            print(rating);
            setState(() {
              note = rating;
            });
          },
        ),
        ButtonTheme(
          child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: Text("Noter !",
                style: TextStyle(color: Colors.white, fontSize: 20.0)),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () {
              sendRating();
            },
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donner une note"),
      ),
      body: ratingSystem(),
    );
  }
}
