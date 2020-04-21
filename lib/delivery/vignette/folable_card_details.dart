import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'card_container.dart';

class FolableCardDetails extends StatelessWidget {
  final DocumentSnapshot demandData;
  final TextStyle titleTextStyle = TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 11,
      height: 1,
      letterSpacing: .2,
      fontWeight: FontWeight.w600,
      color: Color(0xffafafaf));
  final TextStyle contentTextStyle = TextStyle(
      fontFamily: 'Oswald',
      fontSize: 16,
      height: 1.8,
      letterSpacing: .3,
      color: Color(0xff083e64));

  final TextStyle descStyle = TextStyle(
      fontFamily: 'Oswald',
      fontSize: 12.0,
      height: 1.8,
      letterSpacing: .3,
      color: Color(0xff083e64));

  FolableCardDetails({@required this.demandData});

  @override
  Widget build(BuildContext context){

    String remorque = '';
    demandData['typeOfRemorque'].forEach((k, v) {
      if (v == true) {
        remorque += ' ' + k.toString();
      }
    });

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
      ),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Type de remorque'.toUpperCase(),
                          style: titleTextStyle),
                      Text(remorque, style: contentTextStyle),
                    ]),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Desciption'.toUpperCase(), style: titleTextStyle),
                      demandData['description'] == null
                          ? Text(
                        'Pas de description',
                        style: descStyle,
                      )
                          : Container(
                          width: 310,
                          child: Text(
                            demandData['description'],
                            style: descStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          )),
                    ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
