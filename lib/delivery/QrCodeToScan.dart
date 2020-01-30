import 'dart:async';

import 'package:bringme/delivery/deliveryCourses.dart';
import 'package:bringme/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeToScan extends StatelessWidget {
  QrCodeToScan({@required this.courseID, @required this.courseData});

  final String courseID;
  final DocumentSnapshot courseData;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _courseData = courseData.data;

    Widget redirection() {
      Timer(Duration(seconds: 4), () {
        Provider.of<DrawerStateInfo>(context).setCurrentDrawer(1);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => DeliveryCourses()));
        print(
            "4 SECONDES SONT PASSE REDIRECTION DU livreur VERS LA PAGE DES COURSES");
      });

      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Text(''),
              Text(
                "La course a été validée",
                style: TextStyle(fontSize: 17.0),
              ),
              Text(
                "et va être déplacée dans votre historique",
                style: TextStyle(fontSize: 17.0),
              ),
            ],
          ),
        ),
      );
    }

    Widget pageConstruct() {
      return StreamBuilder(
        stream: Firestore.instance
            .collection('deliveryman')
            .document(_courseData['deliveryManId'])
            .collection('historic')
            .document(courseData.documentID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          var data = snapshot.data;
          if (data['completed'] == true) {
            return redirection();
          }
          return Center(
            child: QrImage(
              data: courseID,
              size: 250,
              version: 8,
              backgroundColor: Colors.white30,
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("QR code à faire scanner"),
      ),
      body: pageConstruct(),
    );
  }
}
