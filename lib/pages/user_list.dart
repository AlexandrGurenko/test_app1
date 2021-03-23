import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app1/models/user.dart';
import 'package:test_app1/pages/user_detail.dart';
import 'package:test_app1/services/api_call.dart';
import 'package:test_app1/services/database_sevice.dart';
import 'package:test_app1/widgets/user_widget.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  Future<List<User>> _users;

  @override
  void initState() {
    firstRun();
    super.initState();
  }

  void firstRun() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isFirstRun = pref.getBool('is_first_run') ?? true;

    if (isFirstRun) {
      loadData();
    } else {
      updateUserList();
    }

    pref.setBool('is_first_run', false);
  }

  loadData() {
    DBProvider.db.clearTable();

    setState(() {
      _users = getUsers();
    });

    // Add users to the database and get id
    _users.then((value) async {
      for (int i = 0; i < value.length; i++) {
        value[i] = await DBProvider.db.insertUser(value[i]);
      }
    });
  }

  updateUserList() async {
    Future<List<User>> userList = DBProvider.db.getUsers();

    setState(() {
      _users = userList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(onTap: loadData, child: Icon(Icons.update)),
          )
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder(
          future: _users,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if(snapshot.data.length == 0) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('List is empty'),
                      ElevatedButton(onPressed: loadData, child: Text('Load Users'))
                    ],
                  ),
                );
              }
              return ListView.separated(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => editUser(snapshot.data[index]),
                    child: UserWidget(
                      user: snapshot.data[index],
                      editCallback: () => editUser(snapshot.data[index]),
                      deleteCallback: () => deleteUser(snapshot.data[index].id),
                    ),
                  );
                },
                separatorBuilder: (_, __) {
                  return Divider();
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error');
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  void editUser(User user) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => UserDetail(user: user)))
        .then((value) => updateUserList());
  }

  void deleteUser(int id) {
    DBProvider.db.deleteUser(id);
    updateUserList();
  }
}
