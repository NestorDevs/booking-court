// ignore_for_file: depend_on_referenced_packages

import '../../domain/models/scheduling.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._();
  static Database? _database;

  DatabaseProvider._();

  Future<void> initializeDatabaseProvider() async {
    _database = await _initDatabase();
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, 'scheduling.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE scheduling(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            court TEXT,
            date TEXT,
            user TEXT
          )
        ''');
      },
    );
  }

  //insertar
  Future<void> insertScheduling(Scheduling scheduling) async {
    //final db = await database;
    final db = await DatabaseProvider.instance.database;
    await db.insert('scheduling', scheduling.toMap());
  }

  //obtener
  Future<List<Scheduling>> getScheduling() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('scheduling');
    return maps.map((map) => Scheduling.fromMap(map)).toList();
  }

  //Obtener agendamiento por ID
  Future<Scheduling> getSchedulingById(int id) async {
    final db = await database;
    final maps = await db.query(
      'scheduling',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Scheduling.fromMap(maps.first);
    }
    throw Exception('scheduling not found');
  }

  //Eliminar
  Future<void> deleteScheduling(int id) async {
    final db = await database;
    await db.delete(
      'scheduling',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
