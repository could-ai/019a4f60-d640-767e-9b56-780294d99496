import 'package:flutter/material.dart';
import '../models/match_model.dart';
import '../services/firebase_service.dart';

class MatchResultsScreen extends StatelessWidget {
  const MatchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final caseId = ModalRoute.of(context)?.settings.arguments as String?;
    if (caseId == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(title: const Text('Match Results')),
      body: FutureBuilder<List<Match>>(
        future: FirebaseService().getMatches(caseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('AI Scanning in Progress...'),
                ],
              ),
            );
          }

          final matches = snapshot.data ?? [];
          if (matches.isEmpty) {
            return const Center(
              child: Text('No matches found yet. Scanning continues...'),
            );
          }

          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Match Found'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Confidence: ${match.confidence.toStringAsFixed(1)}%'),
                      Text('Matched: ${match.matchedAt.toLocal()}'),
                      if (match.blockchainTxnId != null)
                        Text('Blockchain ID: ${match.blockchainTxnId}'),
                    ],
                  ),
                  trailing: Icon(
                    match.confidence > 80 ? Icons.check_circle : Icons.warning,
                    color: match.confidence > 80 ? Colors.green : Colors.orange,
                  ),
                  onTap: () => _showMatchDetails(context, match),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showMatchDetails(BuildContext context, Match match) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Match Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Confidence Score: ${match.confidence.toStringAsFixed(1)}%'),
            Text('Match Time: ${match.matchedAt.toLocal()}'),
            if (match.blockchainTxnId != null)
              Text('Blockchain Transaction: ${match.blockchainTxnId}'),
            const SizedBox(height: 16),
            const Text('This match has been logged for verification.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}