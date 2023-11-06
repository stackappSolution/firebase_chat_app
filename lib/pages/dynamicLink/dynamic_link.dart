import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/service/deep_link_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DynamicLinkPage extends StatefulWidget {
  const DynamicLinkPage({super.key});

  @override
  State<DynamicLinkPage> createState() => _DynamicLinkPageState();
}

class _DynamicLinkPageState extends State<DynamicLinkPage> {
  String dynamicLink = '';
  final _url = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: AppText('Deep Link'), centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () async {
                  dynamicLink = await createDynamicLink(dynamicLink);
                setState(() {});
                log('dynamicLink-->$dynamicLink');
              },
              child: const Text('Share Link')),
          GestureDetector(
              onTap: () {
                LinkService().handleDeepLink(dynamicLink);
                _launchUrl();
              },
              child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(dynamicLink))),
        ],
      ),
    );
  }

  Future<String> createDynamicLink(String path) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://7870.page.link/$path',
      link: Uri.parse('https://7870.page.link/$path'),
      androidParameters: const AndroidParameters(
        packageName: 'com.js.signal',
      ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(parameters);
    return dynamicLink.toString();
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(dynamicLink))) {
      throw Exception('Could not launch $_url');
    }
  }
}
