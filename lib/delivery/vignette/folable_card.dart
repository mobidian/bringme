import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'folable_card_proposition.dart';
import 'folable_card_details.dart';
import 'folable_card_summary.dart';
import 'folable_all_animation.dart';

class FolableCard extends StatefulWidget {
  static const double nominalOpenHeight = 400;
  static const double nominalClosedHeight = 160;
  final DocumentSnapshot demandData;
  final Function onClick;
  final GlobalKey scaffoldInstance;

  const FolableCard({Key key, @required this.demandData, @required this.onClick, @required this.scaffoldInstance}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _FolableCardState();
}

class _FolableCardState extends State<FolableCard> {
  FolableCardSummary frontCard;
  FolableCardSummary topCard;
  FolableCardDetails middleCard;
  FoldableCardProposition bottomCard;
  bool _isOpen;

  Widget get backCard =>
      Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: Color(0xffdce6ef)));

  @override
  void initState() {
    super.initState();
    _isOpen = false;
    frontCard = FolableCardSummary(demandData: widget.demandData);
    middleCard = FolableCardDetails(demandData: widget.demandData);
    bottomCard = FoldableCardProposition(demandData: widget.demandData, scaffoldInstance: widget.scaffoldInstance);
  }

  @override
  Widget build(BuildContext context) {
    return FolableAllAnimation(entries: _getEntries(), isOpen: _isOpen, onClick: _handleOnTap);
  }

  List<FoldEntry> _getEntries() {
    return [
      FoldEntry(height: 160.0, front: topCard),
      FoldEntry(height: 160.0, front: middleCard, back: frontCard),
      FoldEntry(height: 80.0, front: bottomCard, back: backCard)
    ];
  }

  void _handleOnTap() {
    widget.onClick();
    setState(() {
      _isOpen = !_isOpen;
      topCard = FolableCardSummary(demandData: widget.demandData, theme: SummaryTheme.dark, isOpen: _isOpen);
    });
  }
}
