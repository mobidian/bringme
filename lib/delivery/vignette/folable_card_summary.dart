import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';


enum SummaryTheme { dark, light }

class FolableCardSummary extends StatelessWidget {
  final DocumentSnapshot demandData;
  final SummaryTheme theme;
  final bool isOpen;

  const FolableCardSummary(
      {Key key,
      this.demandData,
      this.theme = SummaryTheme.light,
      this.isOpen = false})
      : super(key: key);

  Color get mainTextColor {
    Color textColor;
    if (theme == SummaryTheme.dark) textColor = Colors.white;
    if (theme == SummaryTheme.light) textColor = Color(0xFF083e64);
    return textColor;
  }

  Color get secondaryTextColor {
    Color textColor;
    if (theme == SummaryTheme.dark) textColor = Color(0xff61849c);
    if (theme == SummaryTheme.light) textColor = Color(0xFF838383);
    return textColor;
  }

  Color get separatorColor {
    Color color;
    if (theme == SummaryTheme.light) color = Color(0xffeaeaea);
    if (theme == SummaryTheme.dark) color = Color(0xff396583);
    return color;
  }

  TextStyle get bodyTextStyle =>
      TextStyle(color: mainTextColor, fontSize: 13, fontFamily: 'Oswald');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _getBackgroundDecoration(),
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildLogoHeader(),
            _buildSeparationLine(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _buildTicketOrigin(),
                  ),
                  SizedBox(height: 15.0,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _buildTicketDestination(),
                  ),
                ],
              ),
            ),
            _buildBottomIcon()
          ],
        ),
      ),
    );
  }

  _getBackgroundDecoration() {
    if (theme == SummaryTheme.light)
      return BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.white,
      );
    if (theme == SummaryTheme.dark)
      return BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        image: DecorationImage(
            image: AssetImage('assets/mapmondecontour.jpg'), fit: BoxFit.cover),
      );
  }

  _buildLogoHeader() {
    if (theme == SummaryTheme.light)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(Icons.airport_shuttle,size: 17,),
          ),
          Text(DateFormat('dd/MM/yyyy')
              .format(demandData['retraitDate'].toDate()),
              style: TextStyle(
                color: mainTextColor,
                fontFamily: 'OpenSans',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ))
        ],
      );
    if (theme == SummaryTheme.dark)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(Icons.airport_shuttle,size: 17,color: Colors.white,),
          ),
          Text(DateFormat('dd/MM/yyyy')
              .format(demandData['retraitDate'].toDate()),
              style: TextStyle(
                color: mainTextColor,
                fontFamily: 'OpenSans',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ))
        ],
      );
  }

  Widget _buildSeparationLine() {
    return Container(
      width: double.infinity,
      height: 1,
      color: separatorColor,
    );
  }


  Widget _buildTicketOrigin() {

    var headerStyle = TextStyle(
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.bold,
        fontSize: 15.0,
        color: Color(0xFFe46565));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Retrait',
                style: bodyTextStyle.copyWith(fontSize: 16.0),
              ),
              Text(demandData['depart'],
                  style: bodyTextStyle.copyWith(color: secondaryTextColor), overflow: TextOverflow.ellipsis,),
            ],
          ),
        ),
        Text(DateFormat('HH:mm')
            .format(demandData['retraitDate'].toDate()), style: headerStyle,),
      ],
    );
  }


  Widget _buildTicketDestination() {

    var headerStyle = TextStyle(
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.bold,
        fontSize: 15.0,
        color: Color(0xFFe46565));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Livraison',
                style: bodyTextStyle.copyWith(fontSize: 16.0),
              ),
              Text(demandData['destination'],
                  style: bodyTextStyle.copyWith(color: secondaryTextColor), overflow: TextOverflow.ellipsis,),
            ],
          ),
        ),
        Text(DateFormat('HH:mm')
            .format(demandData['deliveryDate'].toDate()), style: headerStyle,),
      ],
    );
  }

  Widget _buildBottomIcon() {
    IconData icon;
    if (theme == SummaryTheme.light) icon = Icons.keyboard_arrow_down;
    if (theme == SummaryTheme.dark) icon = Icons.keyboard_arrow_up;
    return Icon(
      icon,
      color: mainTextColor,
      size: 18,
    );
  }
}

class _AnimatedSlideToRight extends StatefulWidget {
  final Widget child;
  final bool isOpen;

  const _AnimatedSlideToRight({Key key, this.child, @required this.isOpen})
      : super(key: key);

  @override
  _AnimatedSlideToRightState createState() => _AnimatedSlideToRightState();
}

class _AnimatedSlideToRightState extends State<_AnimatedSlideToRight>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1700));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isOpen) _controller.forward(from: 0);
    return SlideTransition(
      position: Tween(begin: Offset(-2, 0), end: Offset(1, 0)).animate(
          CurvedAnimation(curve: Curves.easeOutQuad, parent: _controller)),
      child: widget.child,
    );
  }
}
