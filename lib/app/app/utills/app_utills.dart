import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';



List<Contact> contacts = [];
List<Contact> filteredContacts = [];
bool isLoadingContact = false;

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
void infoLogs(String message) {
  if (kDebugMode) {
    Logger(printer: PrettyPrinter(methodCount: 0)).i(message);
  }
}

void traceLogs(String message) {
  if (kDebugMode) {
    Logger(printer: PrettyPrinter(methodCount: 0)).t(message);
  }
}

void warningLogs(String message) {
  if (kDebugMode) {
    Logger(printer: PrettyPrinter(methodCount: 0)).w(message);
  }
}

void errorLogs(String message) {
  if (kDebugMode) {
    Logger(printer: PrettyPrinter(methodCount: 0)).e(message);
  }

}
