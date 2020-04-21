import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bringme/services/crud.dart';
import 'package:intl/intl.dart';
import 'package:bringme/authentification/auth.dart';


class FoldableCardProposition extends StatefulWidget {

  final demandData;
  final GlobalKey<ScaffoldState> scaffoldInstance;

  FoldableCardProposition({@required this.demandData, @required this.scaffoldInstance});

  @override
  State<StatefulWidget> createState() {
    return _FlightBarCodeState();
  }

}


class _FlightBarCodeState extends State<FoldableCardProposition>{

  CrudMethods crudObj = new CrudMethods();
  final _formKey = new GlobalKey<FormState>();

  int _price;
  DateTime _suggestTime = DateTime.now();

  final BaseAuth auth = new Auth();

  String _userId = '';


  @override
  void initState() {
    super.initState();
    auth.currentUserId().then((id){
      setState(() {
        _userId = id;
      });
    });
  }



  void _showDialog(userId, requestId, currentData) {
    showDialog(
        context: this.context,
        builder: (BuildContext ctx) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                title: Text("Proposition"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _buildRequestInfo(currentData),
                      Form(
                        key: _formKey,
                        child: _buildPriceField(),
                      ),
                      _buildSuggestTimeField(ctx, currentData, setState)
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Fermer"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Envoyer"),
                    onPressed: () {
                      sendProposition(userId, requestId);
                      if (validateAndSave()) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              );
            },
          );
        });
  }


  Widget _buildRequestInfo(currentData) {
    String typeMarchandise = '';
    currentData['typeOfMarchandise'].forEach((k, v) {
      if (v == true) {
        typeMarchandise += ' ' + k.toString();
      }
    });

    String typeRemorque = '';
    currentData['typeOfRemorque'].forEach((k, v) {
      if (v == true) {
        typeRemorque += ' ' + k.toString();
      }
    });

    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Départ"),
              subtitle: Text(currentData['depart'] +
                  ' à ' +
                  DateFormat('HH:mm')
                      .format(currentData['retraitDate'].toDate()) +
                  ' le ' +
                  DateFormat('dd/MM/yy')
                      .format(currentData['retraitDate'].toDate())),
            ),
            ListTile(
              title: Text("Destination"),
              subtitle: Text(currentData['destination'] +
                  ' à ' +
                  DateFormat('HH:mm')
                      .format(currentData['deliveryDate'].toDate()) +
                  ' le ' +
                  DateFormat('dd/MM/yy')
                      .format(currentData['deliveryDate'].toDate())),
            ),
            ListTile(
              title: Text('Marchandise'),
              subtitle: Text(typeMarchandise),
            ),
            ListTile(
              title: Text('Remorque'),
              subtitle: Text(typeRemorque),
            ),
          ],
        ));
  }

  Widget _buildPriceField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        key: new Key('price'),
        decoration: InputDecoration(
          labelText: 'Prix',
          icon: new Icon(
            Icons.euro_symbol,
            color: Colors.grey,
          ),
        ),
        keyboardType: TextInputType.number,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Saisissez un prix';
          }
          return null;
        },
        onSaved: (value) => _price = int.parse(value.trim()),
      ),
    );
  }

  final DateFormat dateFormat = DateFormat('HH:mm');

  Widget _buildSuggestTimeField(ctx, currentData, setState) {
    print(_suggestTime);
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Heure sugérée'),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Text(
              dateFormat.format(_suggestTime),
              style: TextStyle(color: Colors.grey[700]),
            ),
            onPressed: () async {
              FocusScope.of(ctx).unfocus();
              final selectedTime = await _selectTime(ctx);
              if (selectedTime == null) return;

              setState(() {
                _suggestTime = DateTime(
                  currentData["deliveryDate"].toDate().year,
                  currentData["deliveryDate"].toDate().month,
                  currentData["deliveryDate"].toDate().day,
                  selectedTime.hour,
                  selectedTime.minute,
                );
              });
              print(_suggestTime);
            },
          ),
        ],
      ),
    );
  }

  Future<TimeOfDay> _selectTime(BuildContext ctx) {
    return showTimePicker(
      context: ctx,
      initialTime:
      TimeOfDay(hour: _suggestTime.hour, minute: _suggestTime.minute),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }


  void sendProposition(userId, requestId) {
    print(userId);
    print(requestId);

    if (validateAndSave()) {
      crudObj.getDataFromUserDemand(userId, requestId).then((value) {
        Map<String, dynamic> dataMap = value.data;
        List<dynamic> listProposition = dataMap['proposition'];
//      print(listProposition);
        List propositionTemp = List.from(listProposition);
        propositionTemp.add({
          "deliveryManId": _userId,
          "price": _price,
          "suggestTime": _suggestTime
        });

        Map<String, dynamic> updatedProposition = {
          'proposition': propositionTemp
        };
        crudObj.updateDemandData(userId, requestId, updatedProposition);
      });
      widget.scaffoldInstance.currentState.showSnackBar(SnackBar(
          content: Text('Votre proposition a été envoyé à l\'utilisateur !')));
    } else {
      print("le form n'est pas valide");
    }
  }


  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: MaterialButton(
            child: Text('Faire une proposition'),
            onPressed: () {
              setState(() {
                _suggestTime = widget.demandData['deliveryDate'].toDate();
              });
              _showDialog(widget.demandData['userId'], widget.demandData.documentID, widget.demandData);
            }),
      ));
}
