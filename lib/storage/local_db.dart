import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDbHelper{
  static Database _database;
  static final _databaseName = "local_storage";

  static final _tableName = "local_data";
  static final columnId = "id";
  static final columnTitle = "title";
  static final columnDate = "date";


  // last message table and column name
  static final _lastmessage = "last_message";
  static final lastmessageId = "id";
  static final lastmessageTitle = "title";
  static final lastmessageMessage = "message";
  static final lastmessageImage = "image";
  static final lastmessageDate = "date";
  static final lastmessageDocId = "docId";
  static final lastmessageSeen = "seen";
  static final lastmessageType = "type";


  // contact list for offline
  static final _contactListTable = "contact_list";
  static final contactId = "Id";
  static final contactName = "name";
  static final contactNumber = "number";
  static final contactIsExist = "isExist";
  static final contactImage = "image";
  static final contactFromUserId = "fromId";
  static final contactToUserId = "toId";


  LocalDbHelper._privateConstructor();
  static final LocalDbHelper instance = LocalDbHelper._privateConstructor();


  Future<Database> get database async{
    if(_database != null){
      return _database;
    }
    _database = await databaseInitialize();
    return _database;
  }

  Future<Database> databaseInitialize() async {
    Directory dir = await getApplicationDocumentsDirectory();
    var path = join(dir.path,_databaseName);
    var database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return database;
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_lastmessage(
     $lastmessageId INTEGER PRIMARY KEY,
     $lastmessageTitle TEXT NOT NULL,
     $lastmessageMessage TEXT NOT NULL,
     $lastmessageImage TEXT NOT NULL,
     $lastmessageDate TEXT NOT NULL,
     $lastmessageDocId TEXT NOT NULL,
     $lastmessageSeen TEXT NOT NULL,
     $lastmessageType INTEGER NOT NULL)
     ''');

    await db.execute('''
    CREATE TABLE $_tableName(
    $columnId INTEGER PRIMARY KEY,
    $columnTitle TEXT NOT NULL,
    $columnDate TEXT NOT NULL)
    ''');

    await db.execute('''
    CREATE TABLE $_contactListTable(
    $contactId INTEGER PRIMARY KEY,
    $contactName TEXT NOT NULL,
    $contactNumber TEXT NOT NULL,
    $contactIsExist TEXT NOT NULL,
    $contactImage TEXT NOT NULL,
    $contactFromUserId INTEGER NOT NULL,
    $contactToUserId INTEGER NOT NULL)
    ''');
  }


  Future<int> insertData(Map<String,dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future<List<Map<String,dynamic>>> getAllData() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(_tableName, row, where: '$columnId = ?', whereArgs: [id]);
  }


  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$columnId = ?', whereArgs: [id]);
  }

// last message methods
  Future<int> insertLastMessage(Map<String,dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_lastmessage, row);
  }

  Future<List<Map<String,dynamic>>> getAllLastMessage() async {
    Database db = await instance.database;
    return await db.query(_lastmessage);
  }

  Future updateLastMessage(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[lastmessageId];
    return await db.update(_lastmessage, row, where: '$lastmessageId = ?', whereArgs: [id]);
  }


  Future<int> deleteLastMessage(int id) async {
    Database db = await instance.database;
    return await db.delete(_lastmessage, where: '$lastmessageId = ?', whereArgs: [id]);
  }

  // check if data exist
  Future<bool> checkifDataExist(int id) async {
    Database db = await instance.database;
    var qResult = await db.rawQuery("SELECT * FROM $_lastmessage WHERE $lastmessageId = $id");
    if(qResult.isNotEmpty){
      return true;
    }
    return false;
  }



  // contact list CRUD

// last message methods
  Future<int> insertContact(Map<String,dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_contactListTable, row);
  }

  Future<List<Map<String,dynamic>>> getAllContact() async {
    Database db = await instance.database;
    return await db.query(_contactListTable);
  }

  Future updateContact(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[contactId];
    return await db.update(_contactListTable, row, where: '$contactId = ?', whereArgs: [id]);
  }


  Future<int> deleteContact({int id}) async {
    Database db = await instance.database;
    return await db.delete(_contactListTable, where: '$contactId = ?', whereArgs: [id]);
  }

  // check if data exist
  Future<bool> checkIfContactExist(int id) async {
    Database db = await instance.database;
    var qResult = await db.rawQuery("SELECT * FROM $_contactListTable WHERE $contactToUserId = $id");
    if(qResult.isNotEmpty){
      return true;
    }
    return false;
  }





}