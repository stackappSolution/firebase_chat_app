import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../app/app/utills/app_utills.dart';

class DataBaseHelper {
  DataBaseHelper._privateConstructor();

  static final DataBaseHelper instance = DataBaseHelper._privateConstructor();

  static Database? database;
  static  List<Map<String, dynamic>> contactData = [];

  static Future<Database> createDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'chat.db');
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE data (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT, contact TEXT)');
    });
    return database;
  }

  static setContactDetails(name, contact) async {
    try {
      final Database db = await createDB();
      final List<Map<String, dynamic>> existingContacts = await db.rawQuery(
          "SELECT * FROM data WHERE name = '$name' AND contact = '$contact'");
      if (existingContacts.isEmpty) {
        String qry = "INSERT INTO data VALUES(null, '$name', '$contact')";
        await db.rawInsert(qry);
      } else {
        logs('Contact already exists.');
      }
    } catch (e) {
      logs('Error : $e');
    }
  }

  static getContactDetails() async {
    try {
      await createDB().then((value) async {
        String qry = "select * from data";
        value.rawQuery(qry).then((value) {
          contactData = value;
        });
        logs("SQF contacts ---> $contactData");
      });
    } catch (e) {
      logs('Error : $e');
    }
  }
}
