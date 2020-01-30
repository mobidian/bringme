import 'dart:async';

import 'package:bringme/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class ScannerQR extends StatefulWidget {
  ScannerQR({@required this.courseID, @required this.courseData});

  final String courseID;
  final DocumentSnapshot courseData;

  @override
  State<StatefulWidget> createState() {
    return _ScannerQRState();
  }
}

class _ScannerQRState extends State<ScannerQR> {
  bool _showScanner = true;
  String _scannedCode = '';

  _qrCallBack(String code) {
    setState(() {
      _showScanner = false;
      _scannedCode = code;
    });
  }

  Widget scannerConstruct() {
    return QrCamera(
      onError: (context, error) => Text(
        error.toString(),
        style: TextStyle(color: Colors.red),
      ),
      qrCodeCallback: (code) {
        print(widget.courseID);
        print(code);
        _qrCallBack(code);
      },
    );
  }

  Widget endCourseConstruct() {
    if (widget.courseID == _scannedCode) {
      //la course est placé dans l'historique du user
      Map<String, dynamic> _courseData = widget.courseData.data;
      _courseData['completed'] = true;

      Firestore.instance
          .collection('user')
          .document(widget.courseData['userId'])
          .collection('historic')
          .document(widget.courseID)
          .setData(_courseData);

      //la course est aussi placé dans l'historique du livreur
      Firestore.instance
          .collection('deliveryman')
          .document(widget.courseData['deliveryManId'])
          .collection('historic')
          .document(widget.courseID)
          .setData(_courseData);

      Timer(Duration(seconds: 4), () {
        Provider.of<DrawerStateInfo>(context).setCurrentDrawer(1);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => HomePage(
                      userId: widget.courseData['userId'],
                    )));

        print(
            "4 SECONDES SONT PASSE REDIRECTION DU USER VERS LA PAGE D'ACCUEIL");
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 200.0, 20.0, 0.0),
      child: Text(
        "Impossible de valider la course , vous avez peut-être sélectionné la mauvaise course à vérifier",
        style: TextStyle(color: Colors.red[700]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scannez le QR code"),
      ),
      body: _showScanner ? scannerConstruct() : endCourseConstruct(),
    );
  }
}
