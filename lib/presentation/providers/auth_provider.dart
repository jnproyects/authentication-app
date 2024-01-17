
import 'package:authentication_app/presentation/providers/login_form_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:authentication_app/domain/domain.dart';
import 'package:authentication_app/infrastructure/infrastructure.dart';
import 'package:authentication_app/shared/services/services.dart';


part 'auth_provider.g.dart';


@Riverpod(keepAlive: true)
class Auth extends _$Auth {

  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  @override
  AuthState build() {
    checkAuthStatus();
    return AuthState();
  }

  Future<bool> loginUser( String email, String password ) async {

    await Future.delayed( const Duration( milliseconds: 1500 ) );

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);

      return true;

    } on CustomError catch ( e ) {
      logout( e.message );
      throw Exception();
    } catch (e) {
      logout( 'Error no controlado' );
      throw Exception();
    }
  }

  Future<void> registerUser( String fullName, String email, String password ) async {

    await Future.delayed( const Duration( milliseconds: 500 ) );

    try {
      final user = await authRepository.register( fullName, email, password );
      _setLoggedUser( user );
      
    } on CustomError catch ( e ) {
      logout( e.message );
      throw Exception();
    } catch (e) {
      logout( 'Error no controlado' );
      throw Exception();
    }

  }

  void checkAuthStatus() async {

    final token = await keyValueStorageService.getKeyValue<String>('token');
    if ( token == null ) return logout();

    try {
      // final user = await authRepository.checkAuthStatus('dfasdfasf');
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    
    } catch (e) {
      logout();
    }

  }

  void _setLoggedUser( User user ) async {

    await keyValueStorageService.setKeyValue('token', user.token);

    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: ''
    );
  }

  Future<void> logout([ String? errorMessage ]) async {
    
    await keyValueStorageService.removeKey('token');

    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage
    );

    if ( state.errorMessage.isNotEmpty ) {
      final loginFormPr = ref.read( loginFormProvider.notifier );
      loginFormPr.state = loginFormPr.state.copyWith(
        formStatus: LoginFormSubmissionStatus.notValid,
      );
      // ref.invalidate( loginFormProvider );
    }
  }

  Future<Map<String, dynamic>> validateEmailToPasswordRecovery( String email ) async {

    await Future.delayed( const Duration( milliseconds: 1500 ) );

    try {
      
      final resp = await authRepository.validateEmailToPasswordRecovery( email );

      return resp;

    } on CustomError catch ( e ) {
      
      logout( e.message );

      throw Exception();

    } catch (e) {
      logout( 'Error no controlado' );

      throw Exception();
    }

  }

  Future<bool> validateCode( String token, String code ) async {

    await Future.delayed( const Duration( milliseconds: 1500 ) );

    try {
      
      final resp = await authRepository.validateCode(token, code);
      return resp;

    } on CustomError catch ( e ) {
      
      logout( e.message );

      throw Exception();

    } catch (e) {
      logout( 'Error no controlado' );

      throw Exception();
    }

  }

  Future<bool> changePassword( String email, String newPassword ) async {

    await Future.delayed( const Duration( milliseconds: 1500 ) );

    try {
      
      final user = await authRepository.changePassword( email, newPassword );
      _setLoggedUser(user);
      
      return true;

    } on CustomError catch ( e ) {
      
      logout( e.message );

      throw Exception();

    } catch (e) {
      logout( 'Error no controlado' );

      throw Exception();
    }

  }


  


}


enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {

  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking, 
    this.user, 
    this.errorMessage = ''
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    final User? user,
    final String? errorMessage
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus, 
    user: user ?? this.user, 
    errorMessage: errorMessage ?? this.errorMessage, 
  );

}






