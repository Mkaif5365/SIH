class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role;
  final DateTime createdAt;
  
  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
  });
  
  bool get isInspector => role == 'inspector';
  bool get isVendor => role == 'vendor';
  bool get isUser => role == 'user';
  
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'user',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}