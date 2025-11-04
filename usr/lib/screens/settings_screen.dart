import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  String _language = 'English';
  bool _faceBlur = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _language = prefs.getString('language') ?? 'English';
      _faceBlur = prefs.getBool('faceBlur') ?? false;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Privacy')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() => _isDarkMode = value);
              _saveSetting('darkMode', value);
              // TODO: Implement theme switching
            },
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_language),
            trailing: DropdownButton<String>(
              value: _language,
              items: ['English', 'Tamil'].map((lang) =>
                DropdownMenuItem(value: lang, child: Text(lang))
              ).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _language = value);
                  _saveSetting('language', value);
                }
              },
            ),
          ),
          SwitchListTile(
            title: const Text('Face Blur for Privacy'),
            subtitle: const Text('Automatically blur faces in uploaded images'),
            value: _faceBlur,
            onChanged: (value) {
              setState(() => _faceBlur = value);
              _saveSetting('faceBlur', value);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Profile Management'),
            subtitle: const Text('Update personal information'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // TODO: Implement profile editing
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile editing coming soon')),
              );
            },
          ),
          ListTile(
            title: const Text('Data Encryption'),
            subtitle: const Text('Your data is encrypted and secure'),
            trailing: const Icon(Icons.security),
          ),
        ],
      ),
    );
  }
}