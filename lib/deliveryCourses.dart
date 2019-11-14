import 'package:flutter/material.dart';
import 'drawerDelivery.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:bringme/authentification/auth.dart';
import 'package:bringme/services/crud.dart';


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
      setState(() {
        _courseList = value.documents;
      });
      _refreshController.refreshCompleted();
    });
  }

  Future<dynamic> _onLoading() {
    return crudObj.getDeliveryManCourses().then((value) {
      setState(() {
        _courseList = value.documents;
      });
      _refreshController.loadComplete();
    });
  }


  listConstruct(index){
    return ListTile(
      title: Text(_courseList[index]['destination']),
      subtitle: Text(_courseList[index]['userId']),
      trailing: Text(_courseList[index]['deliveryTime']),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("livreur courses"),
      ),
      drawer: DrawerDelivery('deliveryCourses'),
      body: SmartRefresher(
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