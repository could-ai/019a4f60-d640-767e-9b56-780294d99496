class Match {
  final String id;
  final String caseId;
  final String matchedCaseId;
  final double confidence;
  final DateTime matchedAt;
  final String? blockchainTxnId;

  Match({
    required this.id,
    required this.caseId,
    required this.matchedCaseId,
    required this.confidence,
    required this.matchedAt,
    this.blockchainTxnId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'caseId': caseId,
      'matchedCaseId': matchedCaseId,
      'confidence': confidence,
      'matchedAt': matchedAt.toIso8601String(),
      'blockchainTxnId': blockchainTxnId,
    };
  }

  factory Match.fromMap(Map<String, dynamic> map) {
    return Match(
      id: map['id'],
      caseId: map['caseId'],
      matchedCaseId: map['matchedCaseId'],
      confidence: map['confidence'],
      matchedAt: DateTime.parse(map['matchedAt']),
      blockchainTxnId: map['blockchainTxnId'],
    );
  }
}