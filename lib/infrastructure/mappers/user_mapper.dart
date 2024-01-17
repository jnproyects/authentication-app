import 'package:authentication_app/domain/domain.dart';

class UserMapper {

  static User userJsonToEntity( Map<String, dynamic> json ) => User(
    id: json['user']['id'], 
    fullName: json['user']['name'], 
    email: json['user']['email'], 
    roles: List<String>.from( json['user']['role'].map( (role) => role ) ), 
    token: json['token'] ?? ''
  );


}