import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/meaning.dart';
import '../models/diary_entry.dart';
import '../models/strength_day.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  factory DatabaseService() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'znaju_zachem.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    // Таблица смыслов
    await db.execute('''
      CREATE TABLE meanings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        image_path TEXT,
        audio_path TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
    ''');

    // Таблица дневниковых записей
    await db.execute('''
      CREATE TABLE diary_entries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        mood_rating INTEGER NOT NULL,
        note TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Таблица дней силы
    await db.execute('''
      CREATE TABLE strength_days(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL UNIQUE,
        note TEXT,
        image_path TEXT,
        created_at TEXT NOT NULL
      )
    ''');
  }

  // CRUD операции для смыслов
  Future<int> insertMeaning(Meaning meaning) async {
    final db = await database;
    return await db.insert('meanings', meaning.toMap());
  }

  Future<List<Meaning>> getAllMeanings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'meanings',
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) => Meaning.fromMap(maps[i]));
  }

  Future<Meaning?> getMeaning(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'meanings',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Meaning.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateMeaning(Meaning meaning) async {
    final db = await database;
    return await db.update(
      'meanings',
      meaning.toMap(),
      where: 'id = ?',
      whereArgs: [meaning.id],
    );
  }

  Future<int> deleteMeaning(int id) async {
    final db = await database;
    return await db.delete(
      'meanings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD операции для дневниковых записей
  Future<int> insertDiaryEntry(DiaryEntry entry) async {
    final db = await database;
    return await db.insert('diary_entries', entry.toMap());
  }

  Future<List<DiaryEntry>> getAllDiaryEntries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'diary_entries',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => DiaryEntry.fromMap(maps[i]));
  }

  Future<DiaryEntry?> getDiaryEntryByDate(DateTime date) async {
    final db = await database;
    final String dateStr = date.toIso8601String().split('T')[0];
    final List<Map<String, dynamic>> maps = await db.query(
      'diary_entries',
      where: 'date = ?',
      whereArgs: [dateStr],
    );
    if (maps.isNotEmpty) {
      return DiaryEntry.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateDiaryEntry(DiaryEntry entry) async {
    final db = await database;
    return await db.update(
      'diary_entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<int> deleteDiaryEntry(int id) async {
    final db = await database;
    return await db.delete(
      'diary_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD операции для дней силы
  Future<int> insertStrengthDay(StrengthDay day) async {
    final db = await database;
    return await db.insert(
      'strength_days',
      day.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<StrengthDay>> getAllStrengthDays() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'strength_days',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => StrengthDay.fromMap(maps[i]));
  }

  Future<StrengthDay?> getStrengthDayByDate(DateTime date) async {
    final db = await database;
    final String dateStr = date.toIso8601String().split('T')[0];
    final List<Map<String, dynamic>> maps = await db.query(
      'strength_days',
      where: 'date = ?',
      whereArgs: [dateStr],
    );
    if (maps.isNotEmpty) {
      return StrengthDay.fromMap(maps.first);
    }
    return null;
  }

  Future<int> getConsecutiveStrengthDays() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'strength_days',
      orderBy: 'date DESC',
    );
    
    if (maps.isEmpty) return 0;
    
    int consecutive = 0;
    DateTime today = DateTime.now();
    DateTime currentDate = DateTime(today.year, today.month, today.day);
    
    for (var map in maps) {
      DateTime entryDate = DateTime.parse(map['date']);
      if (entryDate.isAtSameMomentAs(currentDate)) {
        consecutive++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    
    return consecutive;
  }

  Future<int> updateStrengthDay(StrengthDay day) async {
    final db = await database;
    return await db.update(
      'strength_days',
      day.toMap(),
      where: 'id = ?',
      whereArgs: [day.id],
    );
  }

  Future<int> deleteStrengthDay(int id) async {
    final db = await database;
    return await db.delete(
      'strength_days',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}