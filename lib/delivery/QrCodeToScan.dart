import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeToScan extends StatelessWidget{

  QrCodeToScan({@required this.courseID});

  final String courseID;

  @override
  Widget build(BuildContext context) {
    
    
    Widget pageConstruct(){
      return Center(
        child: QrImage(
          data: courseID,
          size: 250,
          version: 8,
          backgroundColor: Colors.white30,

        ),
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