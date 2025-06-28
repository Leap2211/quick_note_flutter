import 'package:sqflite/sqflite.dart';
import 'package:quick_app/Entitiy/Note.dart';

class LocalNoteStorage {
  static Database? _db;

  static Future<Database> get db async {
    _db ??= await openDatabase(
      'notes.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE notes (id INTEGER PRIMARY KEY, title TEXT, content TEXT, color TEXT, date TEXT)',
        );
        await db.execute(
          'CREATE TABLE colors (color TEXT PRIMARY KEY)',
        );
      },
    );
    return _db!;
  }

  static Future<void> saveNote(Note note) async {
    final db = await LocalNoteStorage.db;
    await db.insert('notes', note.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Note>> getNotes({
    String? search,
    String? color,
    String? sort,
    DateTime? date,
  }) async {
    final db = await LocalNoteStorage.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: _buildWhereClause(search, color, date),
      whereArgs: _buildWhereArgs(search, color, date),
      orderBy: sort == 'ASC' ? 'date ASC' : 'date DESC',
    );
    return maps.map((e) => Note.fromJson(e)).toList();
  }

  static Future<void> deleteNote(int id) async {
    final db = await LocalNoteStorage.db;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> saveColors(List<String> colors) async {
    final db = await LocalNoteStorage.db;
    final batch = db.batch();
    for (var color in colors) {
      batch.insert('colors', {'color': color}, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  static Future<List<String>> getColors() async {
    final db = await LocalNoteStorage.db;
    final List<Map<String, dynamic>> maps = await db.query('colors');
    return maps.map((e) => e['color'] as String).toList();
  }

  static String? _buildWhereClause(String? search, String? color, DateTime? date) {
    final conditions = <String>[];
    if (search != null && search.isNotEmpty) {
      conditions.add('(title LIKE ? OR content LIKE ?)');
    }
    if (color != null && color.isNotEmpty) {
      conditions.add('color = ?');
    }
    if (date != null) {
      conditions.add('date = ?');
    }
    return conditions.isEmpty ? null : conditions.join(' AND ');
  }

  static List<dynamic> _buildWhereArgs(String? search, String? color, DateTime? date) {
    final args = <dynamic>[];
    if (search != null && search.isNotEmpty) {
      args.addAll(['%$search%', '%$search%']);
    }
    if (color != null && color.isNotEmpty) {
      args.add(color);
    }
    if (date != null) {
      args.add(date.toIso8601String().split('T')[0]);
    }
    return args;
  }
}