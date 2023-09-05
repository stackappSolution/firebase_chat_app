import 'package:get/get.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../app/app/utills/app_utills.dart';

class DataBaseHelper {
  static Database? database;
  static List contactData = [];

  static create_db() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'chat.db');

    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE data (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT, contact TEXT)');
    });
  }

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
    String qry = "insert into data values(null,'$name','$contact')";
    await createDB().then((value) => value.rawInsert(qry));
  }

  static getContactDetails() async {
    await createDB().then((value) async {
      String qry = "select * from data";
      value.rawQuery(qry).then((value) {
        contactData = value;
      });
    });
    logs("conatcs ====>  ${contactData}");
  }

  static removeDetails() async {
    try {
      await database!.execute('DROP TABLE IF EXISTS data');
    } catch (e) {
      print('Error deleting table: $e');
    }
  }


}
