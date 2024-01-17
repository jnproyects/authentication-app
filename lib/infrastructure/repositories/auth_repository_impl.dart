

import 'package:authentication_app/domain/domain.dart';
import 'package:authentication_app/infrastructure/infrastructure.dart';

class AuthRepositoryImpl extends AuthRepository {

  final AuthDataSource authDataSource;

  AuthRepositoryImpl({
    AuthDataSource? authDataSource  
  }) : authDataSource = authDataSource ?? AuthDataSourceImpl() ;

  @override
  Future<User> checkAuthStatus(String token) {
    return authDataSource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return authDataSource.login(email, password);
  }

  @override
  Future<User> register(String fullName, String email, String password) {
    return authDataSource.register(fullName, email, password);
  }
  
  @override
  Future<Map<String, dynamic>> validateEmailToPasswordRecovery(String email) {
    return authDataSource.validateEmailToPasswordRecovery( email );
  }
  
  @override
  Future<bool> validateCode(String token, String code) {
    return authDataSource.validateCode(token, code);
  }
  
  @override
  Future<User> changePassword( String email, String newPassword ) {
    return authDataSource.changePassword(email, newPassword);
  }
  




}