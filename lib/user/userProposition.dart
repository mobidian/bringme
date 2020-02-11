import 'package:flutter/material.dart';
import 'package:bringme/user/myDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bringme/authentification/auth.dart';
import 'propositionFromDemand.dart';
import 'package:intl/intl.dart';

class UserProposition extends StatefulWidget {
  final BaseAuth auth = new Auth();

  @override
  State<StatefulWidget> createState() {
    return _UserPropositionState();
  }
}

class _UserPropositionState extends State<UserProposition> {
  String userId;

  void initState() {
    super.initState();
    widget.auth.currentUserId().then((id) {
      setState(() {
        userId = id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(userId);
    return Scaffold(
      appBar: AppBar(
        title: Text("Proposition"),
      ),
      drawer: MyDrawer(
        currentPage: "proposition",
        userId: userId,
      ),
      body: userId == null ? _showProgressIndicator() : _streamBuilder(),
    );
  }

  Widget _showProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _streamBuilder() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('user')
          .document(userId)
          .collection('demand')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        var data = snapshot.data.documents;
        return pageConstruct(data, context);
      },
    );
  }

  Widget pageConstruct(data, context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        var currentData = data[index];
        var listProposition = currentData["proposition"];
        var demandId = data[index].documentID;
        String marchandise = '';
        currentData['typeOfMarchandise'].forEach((k, v) {
          if (v == true) {
            marchandise += k.toString() + ' - ';
          }
        });
        return Container(
          child: ListTile(
            title: currentData['object'] == null
                ? Text(currentData['depart'])
                : Text(currentData['object']),
            subtitle: Text("arrivé à " +
                DateFormat('HH:mm')
                    .format(currentData['deliveryDate'].toDate())),
            trailing: Text(
              listProposition.length.toString(),
              style: TextStyle(
                  color: Colors.green[600], fontWeight: FontWeight.w800),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => PropositionFromDemand(
                      title: marchandise +
                          ' à ' +
                          DateFormat('HH:mm')
                              .format(currentData['deliveryDate'].toDate()),
                      demandId: demandId,
                      listProposition: listProposition,
                      userId: userId,
                      demandData: currentData,
                    ),
                  ));
            },
          ),
        );
      },
    );
  }
}
