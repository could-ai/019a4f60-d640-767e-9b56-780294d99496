import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final List<String> _alerts = [
    'Possible match found for case #123',
    'New case submitted in your area',
    'Verification required for match #456',
  ];

  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  void _setupFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _alerts.insert(0, message.notification?.body ?? 'New alert');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alerts & Notifications')),
      body: _alerts.isEmpty
          ? const Center(child: Text('No alerts at this time'))
          : ListView.builder(
              itemCount: _alerts.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.notifications, color: Color(0xFF00FF00)),
                    title: Text(_alerts[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _alerts.removeAt(index)),
                    ),
                  ),
                );
              },
            ),
    );
  }
}