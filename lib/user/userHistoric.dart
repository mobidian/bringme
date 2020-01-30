import 'package:bringme/authentification/auth.dart';
import 'package:bringme/services/crud.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'myDrawer.dart';

class UserHistoricPage extends StatefulWidget {
  final BaseAuth auth = new Auth();

  @override
  State<StatefulWidget> createState() {
    return _UserHistoricPageState();
  }
}

class _UserHistoricPageState extends State<UserHistoricPage> {
  String userId;

  RefreshController _refreshController =
  RefreshController(initialRefresh: true);

  CrudMethods crudObj = new CrudMethods();

  List<dynamic> _historicList = [];

  void initState() {
    super.initState();
    widget.auth.currentUserId().then((id) {
      setState(() {
        userId = id;
      });
    });
  }

  Future<dynamic> _refresh() {
    return crudObj.getUserHistoric().then((value) {
      setState(() {
        _historicList = value.documents;
      });
      _refreshController.refreshCompleted();
    });
  }

  Future<dynamic> _onLoading() {
    return crudObj.getUserHistoric().then((value) {
      setState(() {
        _historicList = value.documents;
      });
      _refreshController.loadComplete();
    });
  }

  listConstruct(index) {
    return Card(
      color: index % 2 == 0 ? Colors.white : Colors.white70,
      child: ListTile(
        title: Text(_historicList[index]['destination']),
        subtitle: Text('livré à ' +
            DateFormat('HH:mm')
                .format(_historicList[index]['deliveryDate'].toDate()) +
            ' le ' +
            DateFormat('dd/MM/yyyy')
                .format(_historicList[index]['deliveryDate'].toDate())),
        trailing: Text('-' +
          _historicList[index]['price'] + '€',
          style: TextStyle(color: Colors.green[700], fontSize: 17.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Historique"),
      ),
      drawer: MyDrawer(
        currentPage: 'userHistoric',
        userId: userId,
      ),
      body: SmartRefresher(
          header: BezierCircleHeader(),
          enablePullDown: true,
          enablePullUp: false,
          controller: _refreshController,
          onLoading: _onLoading,
          onRefresh: _refresh,
          child: ListView.builder(
            itemCount: _historicList.length,
            itemBuilder: (context, index) {
              return listConstruct(index);
            },
          )),
    );
  }
}
