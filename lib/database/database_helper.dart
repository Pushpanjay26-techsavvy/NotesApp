import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/notes.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _tableName = 'notes';
  static const String _databaseName = 'notes.db';
  static const int _databaseVersion = 1;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');
  }

  static Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert(_tableName, note.toMap());
  }

  static Future<List<Note>> getAllNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'updatedAt DESC',
    );
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  static Future<List<Note>> searchNotes(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'updatedAt DESC',
    );
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  static Future<List<Note>> getNotesByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'updatedAt DESC',
    );
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  static Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      _tableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  static Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}