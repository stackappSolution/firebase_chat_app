import 'package:flutter/material.dart';
import 'package:signal/app/widget/app_app_bar.dart';

class LinkPage extends StatefulWidget {
  const LinkPage({super.key});

  @override
  State<LinkPage> createState() => _LinkPageState();
}

class _LinkPageState extends State<LinkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: Text('TitlePage'),centerTitle: true),
      body: Center(
        child: Container(height: 200,width: 200,color: Colors.deepOrange),
      ),
    );
  }
}
