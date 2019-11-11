import 'package:flutter/material.dart';


class PropositionFromDemand extends StatefulWidget{

  PropositionFromDemand({this.demandId});

  final String demandId;

  @override
  State<StatefulWidget> createState() {
    return _PropositionFromDemandState();
  }

}


class _PropositionFromDemandState extends State<PropositionFromDemand>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("propositionfromdemand"),
      ),
      body: Center(
        child: Text(widget.demandId),
      ),
    );
  }
}