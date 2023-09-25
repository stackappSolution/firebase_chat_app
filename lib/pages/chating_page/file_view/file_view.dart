import 'package:flutter/material.dart';
import 'package:flutter_file_view/flutter_file_view.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:signal/pages/chating_page/file_view/file_view_model.dart';

import '../../../app/app/utills/app_utills.dart';
import '../../../controller/file_view_controller.dart';

class FileViews extends StatelessWidget {
  FileViewModel? fileViewModel;

  FileViews({super.key});

  @override
  Widget build(BuildContext context) {
    fileViewModel ?? (fileViewModel = FileViewModel(this));
    return GetBuilder<FileViewControllers>(
      init: FileViewControllers(),
      initState: (state) {
        FlutterFileView.init();

        fileViewModel!.argument = Get.arguments;
        fileViewModel!.filePath = fileViewModel!.argument['filePath'];
        logs("parameter data---->${fileViewModel!.filePath}");
      },
      builder: (controller) {
        return SafeArea(
            child: Scaffold(
          body: fileViewModel!.filePath != null
              ? PDFView(
                  filePath: fileViewModel!.filePath,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ));
      },
    );
  }
}
