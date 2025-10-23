import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/patient.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  DatabaseHelper._();
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    await initDatabase();
    return _db!;
  }

  Future<void> initDatabase() async {
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      String path = join(dir.path, 'doctor_app.db');
      _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    } catch (e) {
      throw Exception('Failed to initialize database: $e');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE patients(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        age INTEGER,
        gender TEXT,
        phone TEXT,
        notes TEXT,
        imagePath TEXT,
        documentPath TEXT,
        createdAt TEXT,
        lastVisit TEXT,
        medicalHistory TEXT,
        allergies TEXT,
        bloodType TEXT
      )
    ''');
  }

  Future<int> insert(Patient p) async {
    try {
      Database db = await database;
      return await db.insert('patients', p.toMap());
    } catch (e) {
      throw Exception('Failed to insert patient: $e');
    }
  }

  Future<List<Patient>> getAll() async {
    try {
      Database db = await database;
      final maps = await db.query('patients', orderBy: 'id DESC');
      return List.generate(maps.length, (i) => Patient.fromMap(maps[i]));
    } catch (e) {
      throw Exception('Failed to fetch patients: $e');
    }
  }

  Future<int> update(Patient p) async {
    try {
      Database db = await database;
      return await db.update('patients', p.toMap(), where: 'id = ?', whereArgs: [p.id]);
    } catch (e) {
      throw Exception('Failed to update patient: $e');
    }
  }

  Future<int> delete(int id) async {
    try {
      Database db = await database;
      return await db.delete('patients', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Failed to delete patient: $e');
    }
  }
}
