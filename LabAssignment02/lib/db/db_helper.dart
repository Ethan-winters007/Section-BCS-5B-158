import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/game_result.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("game_results.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE results(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        guess INTEGER NOT NULL,
        status TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertResult(GameResult result) async {
    final db = await instance.database;
    return await db.insert('results', result.toMap());
  }

  Future<List<GameResult>> fetchResults() async {
    final db = await instance.database;
    final maps = await db.query('results', orderBy: 'id DESC');
    return maps.map((e) => GameResult.fromMap(e)).toList();
  }
}
