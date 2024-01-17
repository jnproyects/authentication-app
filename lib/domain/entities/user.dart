class User {

  final String id;
  final String fullName;
  final String email;
  final List<String> roles;
  final String token;

  User({
    required this.id, 
    required this.fullName, 
    required this.email, 
    required this.roles, 
    required this.token
  });

  bool get isAdmin {
    return roles.contains('admin');
  }

}