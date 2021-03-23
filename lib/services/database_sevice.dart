import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:test_app1/models/user.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database _database;

  final String dbName = 'Users.db';
  final String tableName = 'Users';
  final String idColumn = 'id';
  final String fNameColumn = 'first_name';
  final String lNameColumn = 'last_name';
  final String emailColumn = 'email';
  final String photoColumn = 'photo';

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}$dbName';

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute('CREATE TABLE $tableName('
        '$idColumn INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$fNameColumn TEXT, '
        '$lNameColumn TEXT, '
        '$emailColumn TEXT, '
        '$photoColumn TEXT)');
  }

  /// Read
  Future<List<User>> getUsers() async {
    Database db = await this.database;

    final List<Map<String, dynamic>> usersMapList = await db.query(tableName);

    final List<User> users = [];

    usersMapList.forEach((user) {
      users.add(User.fromMap(user));
    });

    return users;
  }

  /// Insert
  Future<User> insertUser(User user) async {
    Database db = await this.database;

    user.id = await db.insert(tableName, user.toMap());
    return user;
  }

  /// Update
  Future<int> updateUser(User user) async {
    Database db = await this.database;

    return await db.update(tableName, user.toMap(),
        where: '$idColumn = ?', whereArgs: [user.id]);
  }

  /// Delete
  Future<int> deleteUser(int id) async {
    Database db = await this.database;

    return await db.delete(tableName, where: '$idColumn = ?', whereArgs: [id]);
  }

  /// Clear Table
  void clearTable() async {
    Database db = await this.database;
    await db.delete(tableName);
  }
}
