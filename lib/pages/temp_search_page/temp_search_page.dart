import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/date_formation.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/app/widget/app_textForm_field.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/modal/user_model.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/service/auth_service.dart';
import 'package:signal/service/database_helper.dart';
import 'package:signal/service/users_service.dart';

class TempSearchPage extends StatelessWidget {
  RxBool isSearch = false.obs;

  bool get searchValue => isSearch.value;
  RxString filteredValue = ''.obs;
  bool isLoading = true;

  final rooms = FirebaseFirestore.instance.collection("rooms");
  final users = FirebaseFirestore.instance.collection("users");

  TempSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildSearchBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => UsersService.instance.getAllUsers(),
      ),
    );
  }

  buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text(
        'Temp Search',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 25),
      ),
    );
  }

  buildSearchBar() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AppTextFormField(onChanged: (value) {}),
        ),
        const SizedBox(height: 14),
        FutureBuilder<List<UserModel>>(
          future: UsersService.instance.getAllUsers(),
          builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
            if (snapshot.hasError) {
              return AppText('${snapshot.error}');
            }
            if (snapshot.hasData) {
              if (snapshot.data != null && (snapshot.data?.isNotEmpty ?? false)) {
                return ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(500.px),
                          child: AppImageAsset(
                            image: snapshot.data?[index].photoUrl,
                            height: 64,
                            width: 64,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AppText(
                            snapshot.data?[index].firstName ?? '',
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemCount: snapshot.data?.length ?? 0,
                );
              }
            }
            return Container();
          },
        ),
        // buildContactList(),
      ],
    );
  }

  getMyChatContactList(number) {
    return rooms.where('members', arrayContains: number).snapshots();
  }

  getNameFromContact(String number) {
    for (var contact in DataBaseHelper.contactData) {
      if (contact["contact"].toString().trim().removeAllWhitespace == number) {
        return contact["name"] ?? "";
      }
    }
    return "Not Saved Yet";
  }

  getLastMessage(id) {
    logs(id);
    return rooms
        .doc(id)
        .collection("chats")
        .orderBy("messageTimestamp", descending: true)
        .limit(1)
        .snapshots();
  }

  getUserName(number) {
    return users.where('phone', isEqualTo: number).snapshots();
  }
}
