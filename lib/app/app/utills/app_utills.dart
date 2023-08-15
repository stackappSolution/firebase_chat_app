import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

extension SnackBar on String {
  copyCode() => Clipboard.setData(ClipboardData(text: this));

  launchLink({LaunchMode? mode}) async {
    try {
      if (await canLaunchUrl(Uri.parse(this))) {
        await launchUrl(Uri.parse(this), mode: mode ?? LaunchMode.externalApplication);
      }
    } catch (e) {
      logs('Catch exception in onTapWhatsapp --> $e');
    }
  }
}

Future<String?> pasteFromClipboard() async {
  ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
  if (data != null) {
    logs('Text pasted from clipboard: ${data.text}');
    return data.text;
  } else {
    logs('Clipboard is empty');
    return '';
  }
}

void logs(String message) {
  if (kDebugMode) {
    print(message);
  }
}
