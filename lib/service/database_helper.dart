import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:signal/app/app/utills/app_utills.dart';

class DatabaseService {
  static  Database? _database; // Use nullable type

  Future openDatabase(String path, {required int version, required Future<Null> Function(Database db, int version) onCreate}) async {
    if (_database == null) {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, 'demo.db');

      _database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
            await db.execute('CREATE TABLE users (id INTEGER PRIMARY KEY, mobileNumber TEXT, name TEXT)');
          });
    }
  }

  static Future<void> insertData({
    required String mobileNumber,required String name,
  }) async {
    if (_database == null) {
      throw Exception("Database not initialized");
    }

    final insertData = "INSERT INTO users (mobileNumber,name) VALUES ('$mobileNumber','$name')";
    logs("insertData--> $insertData");
  }

  static Future<List<Map<String, String>>> getMobileNumbers() async {
    if (_database == null) {
      throw Exception("Database not initialized");
    }

    final List<Map<String, dynamic>> maps = await _database!.query('users');
    logs('mobile-->$maps');

    return maps.map((map) {
      final mobileNumber = map['mobileNumber'] as String;
      final name = map['name'] as String;
      return {
        'mobileNumber': mobileNumber,
        'name': name,
      };
    }).toList();
  }
  static Future<void> fetchDataFromDatabase() async {
    try {
      final mobileNumberList = await DatabaseService.getMobileNumbers();
      // Use mobileNumberList to populate your UI or perform other actions
      for (final map in mobileNumberList) {
        final mobileNumber = map['mobileNumber'];
        final name = map['name'];
        print("Mobile Number: $mobileNumber, Name: $name");
      }
    } catch (e) {
      // Handle errors, e.g., database not initialized
      print("Error fetching data: $e");
    }
  }
}
