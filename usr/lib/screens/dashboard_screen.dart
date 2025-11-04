import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/case_model.dart';
import '../services/firebase_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard - ${user.role.toUpperCase()}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Navigator.pushNamed(context, '/alerts'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<UserProvider>().logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: user.role == 'police' ? _buildPoliceDashboard() : _buildCitizenDashboard(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/upload'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPoliceDashboard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Cases',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Case>>(
              future: FirebaseService().getCases('police_user'), // Mock user ID
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final cases = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: cases.length,
                  itemBuilder: (context, index) {
                    final case = cases[index];
                    return Card(
                      child: ListTile(
                        title: Text(case.name),
                        subtitle: Text('Status: ${case.status}'),
                        trailing: Text('${case.age} years old'),
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/match_results',
                          arguments: case.id,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCitizenDashboard() {
    final user = context.watch<UserProvider>().user!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Reports',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Case>>(
              future: FirebaseService().getCases(user.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final cases = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: cases.length,
                  itemBuilder: (context, index) {
                    final case = cases[index];
                    return Card(
                      child: ListTile(
                        title: Text(case.name),
                        subtitle: Text('Status: ${case.status}'),
                        trailing: Text('${case.age} years old'),
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/match_results',
                          arguments: case.id,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}