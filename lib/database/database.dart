import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

class CardDB {
  CardDB._internal();
  static CardDB get instance => _singleton;
  static final CardDB _singleton = CardDB._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }

    _db = await initDB();

    return _db!;
  }

  Future<Database> initDB() async {
    final documentDIR = await getApplicationDocumentsDirectory();
    final dbPath = join(documentDIR.path, 'mtg_card.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);
    return database;
  }
}
