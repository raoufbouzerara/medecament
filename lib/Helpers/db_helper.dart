import 'dart:async';
import 'dart:io' as io;
import 'package:medecament/Models/medecament.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String PRESENTATION = 'presentation';
  static const String TABLE = 'medecament';
  static const String DB_NAME = 'medecament1.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $NAME TEXT,$PRESENTATION REAL)");
  }

  Future<Medecament> save(Medecament medecament) async {
    var dbClient = await db;
    medecament.id = await dbClient.insert(TABLE, medecament.toMap());
    return medecament;
    /*
    await dbClient.transaction((txn) async {
      var query = "INSERT INTO $TABLE ($NAME) VALUES ('" + employee.name + "')";
      return await txn.rawInsert(query);
    });
    */
  }

  Future<List<Medecament>> getEmployees() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME,PRESENTATION]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Medecament> medecaments = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        medecaments.add(Medecament.fromMap(maps[i]));
      }
    }
    return medecaments;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(Medecament medecament) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, medecament.toMap(),
        where: '$ID = ?', whereArgs: [medecament.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
