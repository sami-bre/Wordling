import 'dart:math';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wordling/models/card.dart';

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
      join(await getDatabasesPath(), 'wordling_cards.db'),
      onCreate: (database, version) {
        print('creating database');
        database.execute('CREATE TABLE cards ('
            'id INEGER NOT NULL, '
            'front TEXT, '
            'back TEXT, '
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
    //     'INSERT INTO cards VALUES (5, "dedi", "bud bud", "bud bud bud", "${Origin.created.name}")');
    List<Map<String, dynamic>> result = await db!.query('cards');
    result.forEach((element) {
      print(element);
    });
  }

  Future<List<Card>> getAllCards() async {
    db = await openDb();
    List<Map<String, dynamic>> raw =
        await db!.query('cards', orderBy: 'id desc');
    List<Card> cards =
        List.generate(raw.length, (index) => Card.fromMap(raw[index]));
    return cards;
  }

  Future<List<Card>> getDueCards() async {
    db = await openDb();
    int now = DateTime.now().millisecondsSinceEpoch;
    List<Map<String, dynamic>> raw = await db!.query(
      'cards',
      where: 'lastStudyTime IS NULL OR (lastStudyTime + interval) <= ?',
      whereArgs: [now],
    );
    List<Card> dueCards =
        List.generate(raw.length, (index) => Card.fromMap(raw[index]));
    return dueCards;
  }

  Future<int> insertCard(Card card) async {
    db = await openDb();
    int id = await db!.insert(
      'cards',
      card.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> deleteCard(Card card) async {
    db = await openDb();
    db!.delete(
      'cards',
      where: 'id=? and origin=?',
      whereArgs: [card.id, card.origin.name],
    );
  }

  Future<Card?> getRandomCard() async {
    db = await openDb();
    List<Card> cards = await getAllCards();
    if (cards.isEmpty) return null;
    return cards[Random().nextInt(cards.length)];
  }

  Future<bool> isSaved(Card card) async {
    db = await openDb();
    List<Map<String, dynamic>> raw = await db!.query('cards',
        where: 'id=? and origin=?', whereArgs: [card.id, card.origin.name]);
    return raw.isNotEmpty;
  }

  Future<int> getNextCreatedCardId() async {
    db = await openDb();
    List<Map<String, dynamic>> raw = await db!.query('cards',
        where: 'origin=?',
        whereArgs: [Origin.created.name],
        orderBy: 'id desc',
        limit: 1);
    if (raw.isEmpty) return 1;
    return raw[0]['id'] + 1;
  }
}
