import 'package:flutter/material.dart';
import 'package:test_app1/models/user.dart';

class UserWidget extends StatelessWidget {
  final User user;
  final VoidCallback deleteCallback;
  final VoidCallback editCallback;

  const UserWidget({Key key, this.user, this.deleteCallback, this.editCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text('${user.firstName} ${user.lastName}'),
            Image.network(user.photo ?? ''),
          ],
        ),
        Column(
          children: [
            ElevatedButton(
              onPressed: editCallback,
              child: Text('Edit', style: TextStyle(color: Colors.white),),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green)),
            ),
            ElevatedButton(
              onPressed: deleteCallback,
              child: Text('Delete', style: TextStyle(color: Colors.white),),
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.red)),
            )
          ],
        ),
      ],
    );
  }
}
