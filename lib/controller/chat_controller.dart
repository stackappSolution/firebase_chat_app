import 'package:get/get.dart';


class ChatController extends GetxController {
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  bool isSearching = false;

  // Method to filter contacts based on search query
  void filterContacts(String query) {
    // Clear the previous filtered contacts
    filteredContacts.clear();

    // If the query is empty, set isSearching to false and return all contacts
    if (query.isEmpty) {
      isSearching = false;
      filteredContacts.addAll(contacts);
    } else {
      // Set isSearching to true
      isSearching = true;

      // Use the query to filter contacts based on your criteria
      filteredContacts.addAll(contacts.where((contact) {
        // Customize this condition based on your search criteria
        return contact.name.toLowerCase().contains(query.toLowerCase());
      }));
    }

    // Update the UI
    update();
  }

}
class Contact {
  final String name;
  final String phoneNumber;

  Contact({
    required this.name,
    required this.phoneNumber,
  });
}
