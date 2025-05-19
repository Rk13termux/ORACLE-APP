import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'vida_organizada.db';
  static const int _databaseVersion = 1;

  // Tablas
  static const String tableFinanzas = 'finanzas';
  static const String tableMetas = 'metas';
  static const String tableProyectos = 'proyectos';
  static const String tableNotas = 'notas';
  static const String tableEnlaces = 'enlaces';

  Future<void> initialize() async {
    _database = await _initDatabase();
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabla Finanzas
    await db.execute('''
      CREATE TABLE $tableFinanzas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo TEXT NOT NULL,
        monto REAL NOT NULL,
        categoria TEXT NOT NULL,
        descripcion TEXT,
        fecha TEXT NOT NULL,
        creado_en TEXT NOT NULL
      )
    ''');

    // Tabla Metas
    await db.execute('''
      CREATE TABLE $tableMetas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descripcion TEXT,
        fecha_objetivo TEXT,
        progreso INTEGER DEFAULT 0,
        completada INTEGER DEFAULT 0,
        categoria TEXT,
        prioridad TEXT,
        creado_en TEXT NOT NULL
      )
    ''');

    // Tabla Proyectos
    await db.execute('''
      CREATE TABLE $tableProyectos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT,
        fecha_inicio TEXT NOT NULL,
        fecha_fin TEXT,
        estado TEXT NOT NULL,
        progreso INTEGER DEFAULT 0,
        categoria TEXT,
        creado_en TEXT NOT NULL
      )
    ''');

    // Tabla Notas
    await db.execute('''
      CREATE TABLE $tableNotas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        contenido TEXT,
        etiquetas TEXT,
        fecha TEXT NOT NULL,
        creado_en TEXT NOT NULL
      )
    ''');

    // Tabla Enlaces
    await db.execute('''
      CREATE TABLE $tableEnlaces (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        url TEXT NOT NULL,
        categoria TEXT,
        es_app INTEGER DEFAULT 0,
        icono TEXT,
        creado_en TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Lógica para actualizar la base de datos en futuras versiones
  }

  // Métodos CRUD genéricos
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    final db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await database;
    return await db.update(
      table,
      data,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await database;
    return await db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }
  
  // Método para ejecutar consultas personalizadas
  Future<List<Map<String, dynamic>>> rawQuery(String query, [List<Object?>? arguments]) async {
    final db = await database;
    return await db.rawQuery(query, arguments);
  }
}