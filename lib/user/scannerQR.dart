import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class ScannerQR extends StatefulWidget {
  ScannerQR({@required this.courseID});

  final String courseID;

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

      Timer(Duration(seconds: 4), () {
        print("Yeah, this line is printed after 4 seconds");
      });

      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Text(''),
              Text("La course a été validée"),
              Text("et va être déplacée dans votre historique"),
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
