// import 'package:path/path.dart';
// import 'package:signal/app/app/utills/app_utills.dart';
// import 'package:sqflite/sqflite.dart';
//
// class DatabaseHelper {
//   static Database? _database; // Use nullable type
//
//   static Future<void> createContactDatabase() async {
//     var databasePath = await getDatabasesPath();
//     String path = join(databasePath, 'demo.db');
//
//     _database = await openDatabase(path, version: 1,
//         onCreate: (Database db, int version) async {
//       await db
//           .execute(
//               'CREATE TABLE users1 (id INTEGER PRIMARY KEY AUTOINCREMENT ,name TEXT, mobileNumber TEXT) ')
//           .then((value) => {logs("my database create successfully")});
//     });
//   }
// static Future<void> insertData({
//   required List mobileNumber,required List name,
// }) async {
//   if (_database == null) {
//     throw Exception("Database not initialized");
//   }
//   final insertData = "INSERT INTO users1 (mobileNumber,name) VALUES ('$mobileNumber','$name')";
//   logs("insertData--> $insertData");
// }
//
// static Future<List<Map<String, String>>> getMobileNumbers() async {
//   if (_database == null) {
//     throw Exception("Database not initialized");
//   }
//   final List<Map<String, dynamic>> maps = await _database!.query('users1');
//   logs('mobile-->$maps');
//   return maps.map((map) {
//     final mobileNumber = map['mobileNumber'] as String;
//     final name = map['name'] as String;
//     return {
//       'mobileNumber': mobileNumber,
//       'name': name,
//     };
//   }).toList();
// }
// static Future<void> fetchDataFromDatabase() async {
//   try {
//     final mobileNumberList = await DatabaseHelper.getMobileNumbers();
//     for (final map in mobileNumberList) {
//       final mobileNumber = map['mobileNumber'];
//       final name = map['name'];
//       print("Mobile Number: $mobileNumber, Name: $name");
//     }
//   } catch (e) {
//     print("Error fetching data: $e");
//   }
// }
// }
//
// class ContactModel {
//   final int? id;
//   late final String name;
//   late final String phoneNumber;
//
//   ContactModel({this.id, required this.name, required this.phoneNumber});
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'phoneNumber': phoneNumber,
//     };
//   }
//
//   factory ContactModel.fromMap(Map<String, dynamic> map) {
//     return ContactModel(
//       id: map['id'],
//       name: map['name'],
//       phoneNumber: map['phoneNumber'],
//     );
//   }
// }
