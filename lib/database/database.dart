import 'dart:async';
import 'dart:developer';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

class CardDB {
  CardDB._internal();
  static CardDB get instance => _singleton;
  static final CardDB _singleton = CardDB._internal();

  String? get dbPath => _db?.path;

  static Database? _db;

  Future<Database> get db async {
    // check if the db path is the same as the one stored in shared preferences
    // then if yes return the db
    // else open the db from the path stored in shared preferences
    // if the path in shared pref is null then return the db or open it with initDB()

    // String? currentPath = await SharedPrefs.instance.getCurrentDBPath();
    // log('Current db path: $currentPath');
    // if (currentPath == null) {
    //   _db = await initDB();
    //   log('init db path: ${_db?.path}');
    //   return _db!;
    // } else if (_db?.path == currentPath) {
    //   log('current db path: ${_db?.path}');
    //   return _db!;
    // } else {
    //   log('Opening db from path: $currentPath');
    //   _db = await openDB(currentPath);
    //   return _db!;
    // }

    if (_db != null) {
      return _db!;
    }
    _db = await initDB();
    if (_db == null) {
      throw Exception('Failed to initialize database');
    }
    return _db!;
  }

  Future<Database> initDB() async {
    final documentDIR = await getApplicationDocumentsDirectory();
    final dbPath = join(documentDIR.path, 'mtg_card.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);
    return database;
  }

  // add method to open database from file pick by user
  Future<Database> openDB(String path) async {
    log('Opening database from path: $path');
    // open the database from the path
    final database = await databaseFactoryIo.openDatabase(path);
    _db = database;

    // copy the db to temp directory for backup purposes
    // final documentDIR = await getApplicationDocumentsDirectory();
    // final dbPath = join(documentDIR.path, 'mtg_card.db');

    // copyCollectionTo(documentDIR.path);
    return database;
  }
}
