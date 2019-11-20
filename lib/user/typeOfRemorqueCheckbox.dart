import 'package:flutter/material.dart';


class TypeOfRemorqueCheckbox extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _TypeOfRemorqueCheckboxState();
  }
}


class _TypeOfRemorqueCheckboxState extends State<TypeOfRemorqueCheckbox>{


  //type de remorque

  bool voiture_citadine_compact = false;
  bool voiture_berline_break = false;
  bool utilitaire_3 = false;
  bool utilitaire_6 = false;
  bool utilitaire_9 = false;
  bool utilitaire_12 = false;
  bool utilitaire_14 = false;
  bool utilitaire_20 = false;
  bool utilitaire_20_plateau_chargement = false;
  bool vehicule_isotherme_frigorifique = false;


  Widget checkbox(String title, bool boolValue) {
    return Row(
//      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Checkbox(
          value: boolValue,
          onChanged: (bool value) {
            switch (title) {
              case "Voiture citadine & compact":
                setState(() {
                  voiture_citadine_compact = value;
                });
                break;
              case "Voiture berline & break":
                setState(() {
                  voiture_berline_break = value;
                });
                break;
              case "Utilitaire 3 m3":
                setState(() {
                  utilitaire_3 = value;
                });
                break;
              case "Utilitaire 6 m3":
                setState(() {
                  utilitaire_6 = value;
                });
                break;
              case "Utilitaire 9 m3":
                setState(() {
                  utilitaire_9 = value;
                });
                break;
              case "Utilitaire 12 m3":
                setState(() {
                  utilitaire_12 = value;
                });
                break;
              case "Utilitaire 14 m3":
                setState(() {
                  utilitaire_14 = value;
                });
                break;
              case "Utilitaire 20 m3":
                setState(() {
                  utilitaire_20 = value;
                });
                break;
              case "Utilitaire 20 m3 avec plateau de chargement":
                setState(() {
                  utilitaire_20_plateau_chargement = value;
                });
                break;
              case "Véhicule isotherme ou frigorifique":
                setState(() {
                  vehicule_isotherme_frigorifique = value;
                });
                break;
            }
          },
        ),
        Flexible(child: Container(child: Text(title, overflow: TextOverflow.ellipsis,),),),
      ],
    );
  }

  Widget _showCheckBox(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        checkbox("Voiture citadine & compact", voiture_citadine_compact),
        checkbox("Voiture berline & break", voiture_berline_break),
        checkbox("Utilitaire 3 m3", utilitaire_3),
        checkbox("Utilitaire 6 m3", utilitaire_6),
        checkbox("Utilitaire 9 m3", utilitaire_9),
        checkbox("Utilitaire 12 m3", utilitaire_12),
        checkbox("Utilitaire 14 m3", utilitaire_14),
        checkbox("Utilitaire 20 m3", utilitaire_20),
        checkbox("Utilitaire 20 m3 avec plateau de chargement", utilitaire_20_plateau_chargement),
        checkbox("Véhicule isotherme ou frigorifique", vehicule_isotherme_frigorifique),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: _showCheckBox()
    );
  }
}