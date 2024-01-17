
import 'package:dio/dio.dart';

import 'package:authentication_app/config/config.dart';
import 'package:authentication_app/domain/domain.dart';
import 'package:authentication_app/infrastructure/infrastructure.dart';


class AuthDataSourceImpl extends AuthDataSource {

  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl
    )
  );

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      // final response = await dio.get(
      final response = await dio.get(
        '/auth/check-status',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token'
          }
        )
      );

      final user = UserMapper.userJsonToEntity( response.data );
      return user;

    } on DioException catch (e) {
      
      if ( e.response?.statusCode == 401 ) {
        throw CustomError( 'Token incorrecto' );
      } 
      // if ( e.type == DioExceptionType.connectionTimeout ) throw ConnectionTimeout();
      if ( e.type == DioExceptionType.connectionTimeout ) {
        throw CustomError('Revisar conexión a internet.' );
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    
    try {
      
      final response = await dio.post(
        '/auth/login', 
        data: {
          'email': email, 
          'password': password
        }
      );

      final user = UserMapper.userJsonToEntity(response.data);
      return user;

    } on DioException catch (e) {
      
      if ( e.response?.statusCode == 401 || e.response?.statusCode == 400 ) {
        throw CustomError( e.response?.data['message'] ?? 'Credenciales incorrectass.' );
      }

      if ( e.type == DioExceptionType.connectionTimeout ) {
        throw CustomError('Revisar conexión a internet.' );
      }

      throw Exception();

    } catch (e) {
      throw Exception();
    }
    
  }

  @override
  Future<User> register( String fullName, String email, String password ) async {
    try {
      
      final response = await dio.post(
        '/auth/register',
        data: {
          "name": fullName,
          "email": email,
          "password": password,
        }
      );

      final user = UserMapper.userJsonToEntity(response.data);
      return user;

    } on DioException catch (e) {

      if ( e.type == DioExceptionType.connectionTimeout ) {
        throw CustomError('Revisar conexión a internet.' );
      }

      throw Exception();

    } catch (e) {

      throw Exception();
    }
    
  }
  
  @override
  Future<Map<String, dynamic>> validateEmailToPasswordRecovery( String email ) async {
    
    try {
      
      final response = await dio.get(
        '/auth/password-recovery',
        data: {
          "email": email,
        }
      );

      return response.data;

    } on DioException catch (e) {

      if ( e.type == DioExceptionType.connectionTimeout ) {
        throw CustomError('Revisar conexión a internet.' );
      }

      throw Exception();

    } catch (e) {

      throw Exception();
    }
  }
  
  @override
  Future<bool> validateCode( String token, String code ) async {
    
    try {
      
      final response = await dio.get(
        '/auth/validate-code',
        data: {
          'token': token,
          'code': code
        }
      );

      return response.data;

    } on DioException catch (e) {

      if ( e.type == DioExceptionType.connectionTimeout ) {
        throw CustomError('Revisar conexión a internet.' );
      }

      throw Exception();

    } catch (e) {

      throw Exception();
    }

  }
  
  @override
  Future<User> changePassword( String email, String newPassword ) async {
    
    try {

      final response = await dio.put(
        '/auth/change-password',
        data: {
          'email': email,
          'newPassword': newPassword
        }
      );

      // retorna userEntity y token
      final user = UserMapper.userJsonToEntity(response.data);
      return user;

    } on DioException catch (e) {
      
      if ( e.response?.statusCode == 401 ) {
        throw CustomError( e.response?.data['message'] ?? 'Credenciales incorrectas' );
      } 
      // if ( e.type == DioExceptionType.connectionTimeout ) throw ConnectionTimeout();
      if ( e.type == DioExceptionType.connectionTimeout ) {
        throw CustomError('Revisar conexión a internet.' );
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }



  }




}