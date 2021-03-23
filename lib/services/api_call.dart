import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test_app1/models/user.dart';

Future<List<User>> getUsers() async {
  var url = 'https://randomuser.me/api/?results=20';

  final response = await http.get(url);

  if (response.statusCode == 200) {
    List<User> users = (jsonDecode(response.body)['results'] as List)
        .map((element) => User.fromJson(element))
        .toList();
    return users;
  }
  return null;
}
