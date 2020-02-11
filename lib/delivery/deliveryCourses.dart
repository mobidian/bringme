import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'drawerDelivery.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:bringme/authentification/auth.dart';
import 'package:bringme/services/crud.dart';
import 'courseDetailsDelivery.dart';


class DeliveryCourses extends StatefulWidget{

  final BaseAuth auth = new Auth();

  @override
  State<StatefulWidget> createState() {
    return _DeliveryCoursesState();
  }
}


class _DeliveryCoursesState extends State<DeliveryCourses>{

  String userId;

  RefreshController _refreshController =
  RefreshController(initialRefresh: true);

  CrudMethods crudObj = new CrudMethods();

  List<dynamic> _courseList = [];

  void initState() {
    super.initState();
    widget.auth.currentUserId().then((id) {
      setState(() {
        userId = id;
      });
    });

  }


  Future<dynamic> _refresh() {
    return crudObj.getDeliveryManCourses().then((value) {
      List<dynamic> templist = value.documents;
      templist.sort((m1,m2){
        return m1['deliveryDate'].compareTo(m2['deliveryDate']);

      });
      setState(() {
        _courseList = value.documents;
      });
      _refreshController.refreshCompleted();
    });
  }

  Future<dynamic> _onLoading() {
    return crudObj.getDeliveryManCourses().then((value) {
      List<dynamic> templist = value.documents;
      templist.sort((m1,m2){
        return m1['deliveryDate'].compareTo(m2['deliveryDate']);

      });
      setState(() {
        _courseList = templist;
      });
      _refreshController.loadComplete();
    });
  }


  listConstruct(index){

    String marchandise = '';

    _courseList[index]['typeOfMarchandise'].forEach((k,v){
      if(v == true){
        marchandise += k.toString() + ' ';
      }
    });

    return ListTile(
      title: Text(_courseList[index]['destination']),
      subtitle: Text('A livrer pour ' + DateFormat('dd/MM/yy HH:mm').format(_courseList[index]['deliveryDate'].toDate())),
      trailing: FlatButton(
        child: Text(
          "détails",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => CourseDetailsDelivery(
                  type: marchandise,
                  time: _courseList[index]['deliveryDate'],
                  coursedata: _courseList[index],
                  courseID: _courseList[index].documentID
                ),
              ));
        },
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Livreur courses"),
      ),
      drawer: DrawerDelivery(currentPage: 'deliveryCourses', userId: userId,),
      body: SmartRefresher(
        header: BezierCircleHeader(),
          enablePullDown: true,
          enablePullUp: false,
          controller: _refreshController,
          onLoading: _onLoading,
          onRefresh: _refresh,
          child: ListView.builder(
            itemCount: _courseList.length,
            itemBuilder: (context, index){
              return listConstruct(index);
            },
          )
      ),
    );
  }
}