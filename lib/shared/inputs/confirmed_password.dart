import 'package:formz/formz.dart';

// Define input validation errors
enum ConfirmedPasswordError { empty, length, format, mismatch }

// Extend FormzInput and provide the input type and error type.
class ConfirmedPassword extends FormzInput<String, ConfirmedPasswordError> {

  final String password;

  static final RegExp passwordRegExp = RegExp(
    r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$',
  );

  // Call super.pure to represent an unmodified form input.
  const ConfirmedPassword.pure({ this.password = '' }) : super.pure('');

  // Call super.dirty to represent a modified form input.
  const ConfirmedPassword.dirty( { required this.password, String value = '' } ) : super.dirty(value);


  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == ConfirmedPasswordError.empty ) return 'El campo es requerido';
    if ( displayError == ConfirmedPasswordError.length ) return 'Mínimo 6 caracteres';
    if ( displayError == ConfirmedPasswordError.format ) return 'Debe contener Mayúscula, letras y un número';
    if ( displayError == ConfirmedPasswordError.mismatch ) return 'Las contraseñas deben coincidir';

    return null;
  }


  // Override validator to handle validating a given input value.
  @override
  ConfirmedPasswordError? validator(String value) {

    if ( value.isEmpty || value.trim().isEmpty ) return ConfirmedPasswordError.empty;
    if ( value.length < 6 ) return ConfirmedPasswordError.length;
    if ( !passwordRegExp.hasMatch(value) ) return ConfirmedPasswordError.format;
    if ( password != value ) return ConfirmedPasswordError.mismatch;

    return null;
  }
}