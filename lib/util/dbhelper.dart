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
        database.execute('CREATE TABLE definitions ('
            'id INEGER NOT NULL, '
            'word TEXT, '
            'definition TEXT, '
            'example TEXT, '
            'origin TEXT NOT NULL, '
            'n INTEGER, '
            'eFactor REAL, '
            'interval REAL, '
            'lastStudyTime REAL, '
            'PRIMARY KEY (id, origin))');
      },
      version: version,
    );
    return db!;
  }

  Future testDb() async {
    db = await openDb();
    // await db!.execute(
    //     'INSERT INTO definitions VALUES (5, "dedi", "bud bud", "bud bud bud", "${Origin.created.name}")');
    List<Map<String, dynamic>> result = await db!.query('definitions');
    result.forEach((element) {
      print(element);
    });
  }

  Future<List<Definition>> getAllDefinitions() async {
    db = await openDb();
    List<Map<String, dynamic>> raw =
        await db!.query('definitions', orderBy: 'id desc');
    List<Definition> defns =
        List.generate(raw.length, (index) => Definition.fromMap(raw[index]));
    return defns;
  }

  Future<List<Definition>> getDueDefinitions() async {
    db = await openDb();
    int now = DateTime.now().millisecondsSinceEpoch;
    List<Map<String, dynamic>> raw = await db!.query(
      'definitions',
      where: 'lastStudyTime IS NULL OR (lastStudyTime + interval) <= ?',
      whereArgs: [now],
    );
    List<Definition> dueDefns =
        List.generate(raw.length, (index) => Definition.fromMap(raw[index]));
    return dueDefns;
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
      where: 'id=? and origin=?',
      whereArgs: [defn.id, defn.origin.name],
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
        where: 'id=? and origin=?', whereArgs: [defn.id, defn.origin.name]);
    return raw.isNotEmpty;
  }

  Future<int> getNextCreatedDefinitionId() async {
    db = await openDb();
    List<Map<String, dynamic>> raw = await db!.query('definitions',
        where: 'origin=?',
        whereArgs: [Origin.created.name],
        orderBy: 'id desc',
        limit: 1);
    if (raw.isEmpty) return 1;
    return raw[0]['id'] + 1;
  }
}
