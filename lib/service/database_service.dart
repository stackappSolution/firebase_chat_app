import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/service/auth_service.dart';

class DatabaseService {
  DocumentReference<Map<String, dynamic>> users = FirebaseFirestore.instance
      .collection('users')
      .doc(AuthService.auth.currentUser?.uid);
  String documentId = '';

  Future<String?> addUser(
      {required String firstName,
        required String lastName,
        required String photo,
        required String phone,
        required String fcmToken}) async {
    try {
      users.set({
        'id': AuthService.auth.currentUser!.uid,
        'firstName': firstName,
        'lastName': lastName,
        'photoUrl': photo,
        'phone': phone,
        'fcmToken': fcmToken,
      });
      return 'success';
    } catch (e) {
      return 'Error adding user';
    }
  }

  getUserStream() {
    final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('users')
        .where('id', isNotEqualTo: AuthService.auth.currentUser?.uid)
        .snapshots();
    return usersStream;
  }

  addNewMessage({
    String? profile,
    String? groupName,
    required List<String> members,
    required String massage,
    required String sender,
    required bool isGroup,
  }) async {
    bool isFirst = await checkFirst(members);

    if (isFirst) {
      DocumentReference doc =
      await FirebaseFirestore.instance.collection('rooms').add({
        'id': '',
        'members': members,
        'isGroup': isGroup,
        'time': DateTime.now().millisecondsSinceEpoch,
      });
      await doc.update({'id': doc.id});


      if (isGroup == true) {
        await doc.update({'id': doc.id});
        await FirebaseFirestore.instance
            .collection('rooms')
            .doc(doc.id)
            .update({
          'groupProfile': profile,
          'groupName': groupName,
        }).then((value) => Get.toNamed(RouteHelper.getChattingScreen(),
            arguments: members,
            parameters: {
              'photoUrl': profile!,
              'firstName': groupName!,
              'phoneNumber': AuthService.auth.currentUser!.phoneNumber!,
            }));
        addChatMessages(message: massage, sender: sender, members: members);
      }
      addChatMessages(message: massage, sender: sender, members: members);
      documentId = doc.id;
    }
  }

  Future<bool> checkFirst(List<String> members) async {
    QuerySnapshot userMessages = await FirebaseFirestore.instance
        .collection('rooms')
        .where('members', isEqualTo: members)
        .get();
    return userMessages.docs.isEmpty;
  }

  addChatMessages({
    required List<String> members,
    required String message,
    required String sender,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .where('members', isEqualTo: members)
        .get();
    logs(querySnapshot.docs.first.id);
    FirebaseFirestore.instance
        .collection('rooms')
        .doc(querySnapshot.docs.first.id)
        .collection('chats')
        .add({
      'message': message,
      'sender': sender,
      'timeStamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
  getChatStream(String id) {
    final Stream<QuerySnapshot> chatStream = FirebaseFirestore.instance
        .collection('rooms')
        .doc(id)
        .collection('chats')
        .snapshots();
    return chatStream;
  }
}