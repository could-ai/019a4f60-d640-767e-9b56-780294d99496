class Case {
  final String id;
  final String userId;
  final String name;
  final int age;
  final String gender;
  final String description;
  final String location;
  final List<String> imageUrls;
  final String status; // 'scanning', 'match_found', 'verified', 'closed'
  final DateTime submittedAt;

  Case({
    required this.id,
    required this.userId,
    required this.name,
    required this.age,
    required this.gender,
    required this.description,
    required this.location,
    required this.imageUrls,
    required this.status,
    required this.submittedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'age': age,
      'gender': gender,
      'description': description,
      'location': location,
      'imageUrls': imageUrls,
      'status': status,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  factory Case.fromMap(Map<String, dynamic> map) {
    return Case(
      id: map['id'],
      userId: map['userId'],
      name: map['name'],
      age: map['age'],
      gender: map['gender'],
      description: map['description'],
      location: map['location'],
      imageUrls: List<String>.from(map['imageUrls']),
      status: map['status'],
      submittedAt: DateTime.parse(map['submittedAt']),
    );
  }
}