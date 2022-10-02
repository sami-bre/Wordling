import 'dart:math';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wordling/models/definition.dart';

class DbHelper {
  final int version = 1;
  Database? db;
  static final DbHelper _instance = DbHelper._internal();

  DbHelper._internal();

  factory DbHelper() {
    return _instance;
  }

  Future<Database> openDb() async {
    db ??= await openDatabase(
      join(await getDatabasesPath(), 'wordling_definitions.db'),
      onCreate: (database, version) {
        print('creating database');
        database.execute(
            'CREATE TABLE definitions (id INEGER PRIMARY KEY, word TEXT, definition TEXT, example TEXT)');
      },
      version: version,
    );
    return db!;
  }

  Future testDb() async {
    db = await openDb();
    await db!.execute(
        'INSERT INTO definitions VALUES (5, "dedi", "bud bud", "bud bud bud")');
    List<Map<String, dynamic>> result =
        await db!.query('definitions', orderBy: 'id desc');
    print(result[0].toString());
  }

  Future<List<Definition>> getAllDefinitions() async {
    db = await openDb();
    List<Map<String, dynamic>> raw =
        await db!.query('definitions', orderBy: 'id desc');
    List<Definition> defns =
        List.generate(raw.length, (index) => Definition.fromMap(raw[index]));
    return defns;
  }

  Future<int> insertDefinition(Definition defn) async {
    db = await openDb();
    int id = await db!.insert(
      'definitions',
      defn.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> deleteDefinition(Definition defn) async {
    db = await openDb();
    db!.delete(
      'definitions',
      where: 'id=?',
      whereArgs: [defn.id],
    );
  }

  Future<Definition?> getRandomDefinition() async {
    db = await openDb();
    List<Definition> defns = await getAllDefinitions();
    if (defns.isEmpty) return null;
    return defns[Random().nextInt(defns.length)];
  }

  Future<bool> isSaved(Definition defn) async {
    db = await openDb();
    List<Map<String, dynamic>> raw = await db!.query('definitions',
        where: 'id=?', whereArgs: [defn.id], orderBy: 'id desc');
    return raw.isNotEmpty;
  }
}
