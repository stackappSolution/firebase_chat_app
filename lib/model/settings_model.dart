import 'dart:convert';

import 'package:flutter/material.dart';

List<SettingsModel> settingsModelFromJson(String str) => List<SettingsModel>.from(json.decode(str).map((x) => SettingsModel.fromJson(x)));

String settingsModelToJson(List<SettingsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SettingsModel {
  String title;
  String icon;
  GestureTapCallback onTap;

  SettingsModel({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
    title: json["title"],
    icon: json["icon"],
    onTap: json["ontap"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "icon": icon,
    "ontap": onTap,
  };
}