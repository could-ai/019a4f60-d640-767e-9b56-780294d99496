import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/case_model.dart';
import '../models/match_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mock data for demonstration since Supabase not connected
  final List<Case> _mockCases = [];
  final List<Match> _mockMatches = [];

  // Authentication methods (mocked for now)
  Future<User?> signIn(String email, String password) async {
    // TODO: Replace with real Firebase Auth when backend is connected
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    if (email == 'police@example.com' && password == 'password') {
      return User(id: 'police_1', email: email, role: 'police', name: 'Officer John');
    } else if (email == 'citizen@example.com' && password == 'password') {
      return User(id: 'citizen_1', email: email, role: 'citizen', name: 'Jane Citizen');
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Case management (mocked)
  Future<List<Case>> getCases(String userId) async {
    // TODO: Replace with real Firestore queries
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockCases.where((c) => c.userId == userId).toList();
  }

  Future<void> addCase(Case caseItem) async {
    // TODO: Add to Firestore
    _mockCases.add(caseItem);
  }

  // Match management (mocked)
  Future<List<Match>> getMatches(String caseId) async {
    // TODO: Replace with real Firestore queries
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockMatches.where((m) => m.caseId == caseId).toList();
  }

  Future<void> addMatch(Match match) async {
    // TODO: Add to Firestore
    _mockMatches.add(match);
  }
}