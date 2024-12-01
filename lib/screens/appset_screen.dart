import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppSetScreen extends StatefulWidget {
  const AppSetScreen({super.key});

  @override
  _AppSetScreenState createState() => _AppSetScreenState();
}

class _AppSetScreenState extends State<AppSetScreen> {
  // Firebase settings data
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  String language = 'English';

  // User authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // Retrieve user settings from Firebase or local storage
    _loadUserSettings();
  }

  void _loadUserSettings() {
    // Load user settings from Firebase or SharedPreferences (or other storage)
    // For this example, assume they're set to default values.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4B61DD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B61DD),
        elevation: 0,
        title: const Text(
          'Application Settings',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Notifications'),
            _buildToggleOption(
              label: 'Enable Notifications',
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
                // Update settings in Firebase or local storage
                _updateNotificationsSetting(value);
              },
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Appearance'),
            _buildToggleOption(
              label: 'Dark Mode',
              value: darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  darkModeEnabled = value;
                });
                // Update dark mode setting in Firebase or local storage
                _updateDarkModeSetting(value);
              },
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Language'),
            _buildSelectableOption(
              label: 'App Language',
              value: language,
              onSelect: () => _showLanguageDialog(),
            ),
            const SizedBox(height: 20),

            // Logout button
            Center(
              child: ElevatedButton(
                onPressed: _logout,
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to logout user using Firebase
  void _logout() async {
    try {
      await _auth.signOut();
      // Navigate to login screen or home page
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      // Handle logout error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  // Update notification setting in Firebase
  void _updateNotificationsSetting(bool value) {
    // You can save the setting to Firebase Firestore, for example:
    // FirebaseFirestore.instance.collection('users').doc(userId).update({
    //   'notificationsEnabled': value,
    // });
  }

  // Update dark mode setting in Firebase
  void _updateDarkModeSetting(bool value) {
    // You can save the setting to Firebase Firestore or SharedPreferences
  }

  // Widget to create section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget to create a toggle switch option
  Widget _buildToggleOption({required String label, required bool value, required ValueChanged<bool> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  // Widget to create a selectable option that opens a dialog
  Widget _buildSelectableOption({required String label, required String value, required VoidCallback onSelect}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                onPressed: onSelect,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Method to show a dialog for selecting a language
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption('English'),
              _buildLanguageOption('Spanish'),
              _buildLanguageOption('French'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Helper method to create language options
  Widget _buildLanguageOption(String languageOption) {
    return RadioListTile<String>(
      title: Text(languageOption),
      value: languageOption,
      groupValue: language,
      onChanged: (value) {
        setState(() {
          language = value!;
        });
        Navigator.of(context).pop();
      },
    );
  }
}
