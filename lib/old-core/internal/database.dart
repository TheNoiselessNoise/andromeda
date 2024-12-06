import 'package:sqflite/sqflite.dart';
import "package:andromeda/old-core/core.dart";

class DatabaseService {
  static Database? _database;

  DatabaseService._();

  static Future<Database> getDatabase() async {
    return _database ??= await openDatabase(AppConfig.defaultDatabasePath!);
  }

  static Future<void> init() async {
    _database ??= await getDatabase();
  }
}
