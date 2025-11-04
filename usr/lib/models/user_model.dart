class User {
  final String id;
  final String email;
  final String role; // 'police' or 'citizen'
  final String name;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'name': name,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      role: map['role'],
      name: map['name'],
    );
  }
}