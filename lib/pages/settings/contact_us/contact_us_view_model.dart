import 'package:signal/pages/settings/contact_us/contact_us_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsViewModel {
  ContactUsScreen? contactUsScreen;

  void includeDebugUrl() async {
    final Uri url =
        Uri.parse('https://support.signal.org/hc/en-us/articles/360007318591');
    if (!await launchUrl(url,mode: LaunchMode.externalNonBrowserApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void faqUrl() async {
    final Uri url = Uri.parse('https://support.signal.org/hc/en-us');
    if (!await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  ContactUsViewModel(this.contactUsScreen);
}
