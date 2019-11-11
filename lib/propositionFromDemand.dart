import 'package:flutter/material.dart';


class PropositionFromDemand extends StatefulWidget{

  PropositionFromDemand({@required this.demandId, @required this.listProposition});

  final String demandId;
  final List<dynamic> listProposition;

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
      body: Column(
        children: <Widget>[
          Text(widget.demandId),
          Expanded(
            child: _buildListOfProposition(),
          ),
        ],
      )
    );
  }

  _buildListOfProposition(){

    return ListView.builder(
      itemCount: widget.listProposition.length,
      itemBuilder: (context, index){
        return Container(
          child: ListTile(
            title: Text(widget.listProposition[index]['deliveryManId']),
            subtitle: Text(widget.listProposition[index]['price'].toString()),
            trailing: FlatButton(
              child: Icon(Icons.check_circle_outline),
              onPressed: (){},
            ),
          ),
        );
      },
    );
  }

}