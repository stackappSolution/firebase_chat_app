import 'package:permission_handler/permission_handler.dart';

class PermissionUtil{
  static Future<void> getPermission() async {
    var status = await Permission.camera.status;
    var status1 = await Permission.storage.status;
    if (status.isDenied && status1.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.storage,
      ].request();
    }
  }
}