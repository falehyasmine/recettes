import 'package:flutter/src/widgets/framework.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'user_model.dart';
import 'recette_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialisation de la base de données
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'app_database.db');

    // **TEMPORAIRE** : Supprimez la base pour repartir à zéro (à retirer en production)
    // await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 4, // Incrémentez la version en cas de modification de structure
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  // Création des tables avec "IF NOT EXISTS"
  Future<void> _createTables(Database db, [int? version]) async {
    await db.execute(
      'CREATE TABLE IF NOT EXISTS users('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'nom TEXT, '
      'email TEXT, '
      'password TEXT'
      ')',
    );

    await db.execute(
      'CREATE TABLE IF NOT EXISTS recettes('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'titre TEXT, '
      'ingredients TEXT, '
      'imagePath TEXT'
      ')',
    );
  }

  // Mise à jour de la base de données
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute('DROP TABLE IF EXISTS users');
      await db.execute('DROP TABLE IF EXISTS recettes');
      await _createTables(db);
    }
  }

  // MÉTHODES POUR LES UTILISATEURS
  Future<void> insertUser(User user, BuildContext context) async {
    final db = await database;
    await db.insert('users', user.toMap());
  }

  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final result = await db.query('users');
    return result.map((map) => User.fromMap(map)).toList();
  }

  // MÉTHODES POUR LES RECETTES
  Future<void> insertRecette(Recette recette) async {
    final db = await database;
    await db.insert('recettes', recette.toMap());
  }

  Future<List<Recette>> getAllRecettes() async {
    final db = await database;
    final result = await db.query('recettes');
    return result.map((map) => Recette.fromMap(map)).toList();
  }

  Future<void> deleteRecette(int id) async {
    final db = await database;
    await db.delete('recettes', where: 'id = ?', whereArgs: [id]);
  }

  Stream<List<Recette>> recettesStream() {
    return Stream.periodic(
      Duration(seconds: 1), // Intervalle de rafraîchissement
      (_) => getAllRecettes(),
    ).asyncMap((recettes) async => recettes);
  }
}
