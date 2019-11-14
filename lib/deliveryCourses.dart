import 'package:flutter/material.dart';
import 'drawerDelivery.dart';


class DeliveryCourses extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _DeliveryCoursesState();
  }
}


class _DeliveryCoursesState extends State<DeliveryCourses>{
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("livreur courses"),
      ),
      drawer: DrawerDelivery('deliveryCourses'),
      body: Center(child: Text('hello courses livreur'),),
      //bug quand on clique sur accuil le drawer renvoi ver "/" qui renvoi vers rootpage
      // la rootpage ensuite comprend pas qu'il s'agit d'un livreur et fait comme si il s'agissait d'un user putain
    );
  }
}