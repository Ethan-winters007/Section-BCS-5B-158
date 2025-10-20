import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Movie {
  int? id;
  String name, platform, rating, genre, category, language, country, duration, description, releaseDate, posterPath;

  Movie({
    this.id,
    required this.name,
    required this.platform,
    required this.rating,
    required this.genre,
    required this.category,
    required this.language,
    required this.country,
    required this.duration,
    required this.description,
    required this.releaseDate,
    required this.posterPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'platform': platform,
      'rating': rating,
      'genre': genre,
      'category': category,
      'language': language,
      'country': country,
      'duration': duration,
      'description': description,
      'releaseDate': releaseDate,
      'posterPath': posterPath,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      name: map['name'],
      platform: map['platform'],
      rating: map['rating'],
      genre: map['genre'],
      category: map['category'],
      language: map['language'],
      country: map['country'],
      duration: map['duration'],
      description: map['description'],
      releaseDate: map['releaseDate'],
      posterPath: map['posterPath'],
    );
  }
}

class MovieDatabase {
  static final MovieDatabase instance = MovieDatabase._init();
  static Database? _database;
  MovieDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('movies.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE movies(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        platform TEXT,
        rating TEXT,
        genre TEXT,
        category TEXT,
        language TEXT,
        country TEXT,
        duration TEXT,
        description TEXT,
        releaseDate TEXT,
        posterPath TEXT
      )
    ''');
  }

  Future<int> create(Movie movie) async {
    final db = await instance.database;
    return await db.insert('movies', movie.toMap());
  }

  Future<List<Movie>> readAllMovies() async {
    final db = await instance.database;
    final result = await db.query('movies');
    return result.map((map) => Movie.fromMap(map)).toList();
  }

  Future<int> update(Movie movie) async {
    final db = await instance.database;
    return db.update('movies', movie.toMap(), where: 'id = ?', whereArgs: [movie.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('movies', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
