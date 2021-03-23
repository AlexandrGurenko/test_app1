import 'package:flutter/material.dart';
import 'package:test_app1/models/user.dart';
import 'package:test_app1/services/database_sevice.dart';

class UserDetail extends StatefulWidget {
  final User user;

  const UserDetail({Key key, this.user}) : super(key: key);

  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  TextEditingController _fNameController;
  TextEditingController _lNameController;
  TextEditingController _emailController;

  @override
  void initState() {
    _fNameController = TextEditingController(text: widget.user.firstName);
    _lNameController = TextEditingController(text: widget.user.lastName);
    _emailController = TextEditingController(text: widget.user.email);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.user.firstName), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.network(widget.user.photo),
                TextField(controller: _fNameController),
                TextField(controller: _lNameController),
                TextField(controller: _emailController),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.user.firstName = _fNameController.text;
                              widget.user.lastName = _lNameController.text;
                              widget.user.email = _emailController.text;
                            });
                            updateUser(widget.user);
                          },
                          child: Text('Update')),
                      SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                          onPressed: () => deleteUser(widget.user.id),
                          child: Text('Delete'),
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red)),)
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  updateUser(User user) {
    DBProvider.db.updateUser(user);
  }

  void deleteUser(int id) {
    DBProvider.db.deleteUser(id);
    Navigator.pop(context);
  }
}
