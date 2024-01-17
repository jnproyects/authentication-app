
import '../entities/user.dart';

abstract class AuthDataSource {

  Future<User> login( String email, String password );
  
  Future<User> register( String fullName, String email, String password );
  
  Future<User> checkAuthStatus( String token );

  Future<Map<String, dynamic>> validateEmailToPasswordRecovery( String email );

  Future<bool> validateCode( String token, String code );

  Future<User> changePassword( String email, String newPassword );

}