import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/employee.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'employee_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE employees(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        jobRole TEXT,
        startDate TEXT,
        endDate TEXT
      )
    ''');
  }

  Future<List<Employee>> getEmployees() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('employees');
    return List.generate(maps.length, (index) => Employee.fromMap(maps[index]));
  }

  Future<int> insertEmployee(Employee employee) async {
    final Database db = await database;
    return await db.insert('employees', employee.toMap());
  }

  Future<int> updateEmployee(Employee employee) async {
    final Database db = await database;
    return await db.update(
      'employees',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  Future<int> deleteEmployee(Employee employee) async {
    final Database db = await database;
    return await db.delete(
      'employees',
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }
}
