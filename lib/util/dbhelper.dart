import 'dart:math';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wordling/models/word.dart';

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
      join(await getDatabasesPath(), 'testdat.db'),
      onCreate: (database, version) {
        database.execute(
            'CREATE TABLE words (id INEGER PRIMARY KEY, term TEXT, definition TEXT, example TEXT)');
      },
      version: version,
    );
    return db!;
  }

  Future testDb() async {
    db = await openDb();
    await db!.execute(
        'INSERT INTO words VALUES (5, "dedi", "bud bud", "bud bud bud")');
    List<Map<String, dynamic>> result =
        await db!.query('words', orderBy: 'id desc');
    print(result[0].toString());
  }

  Future<Word?> getRandomWord() async {
    db = await openDb();
    List<Map<String, dynamic>> raw = await db!.query(
      'words',
      orderBy: 'id desc',
      limit: 1,
    );
    int lastId;
    try {
      lastId = raw[0]['id'];
    } on Error {
      return null;
    }
    int randomId = Random().nextInt(lastId) + 1;
    raw = await db!.query('words', where: 'id=?', whereArgs: [randomId]);
    Word word = Word.fromMap(raw[0]);
    return word;
  }

  Future<List<Word>> getAllWords() async {
    List<Map<String, dynamic>> raw =
        await db!.query('words', orderBy: 'id desc');
    List<Word> words =
        List.generate(raw.length, (index) => Word.fromMap(raw[index]));
    return words;
  }

  Future<void> insertWord(Word word) async {
    db!.insert(
      'words',
      word.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteWord(Word word) async {
    db!.delete(
      'words',
      where: 'id=?',
      whereArgs: [word.id],
    );
  }
}
