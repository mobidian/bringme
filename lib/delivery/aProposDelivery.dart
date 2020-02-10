import 'package:flutter/material.dart';
import 'drawerDelivery.dart';

class AProposDelivery extends StatelessWidget{


  Widget constructPage(){
    return Center(
      child: Text('À Propos'),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("A Propos"),
      ),
      body: constructPage(),
      drawer: DrawerDelivery(currentPage: "aPropos"),
    );
  }
}