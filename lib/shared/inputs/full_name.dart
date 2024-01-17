import 'package:formz/formz.dart';

// Define input validation errors
enum FullNameError { empty, format }

// Extend FormzInput and provide the input type and error type.
class FullName extends FormzInput<String, FullNameError> {

  static final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z]+( [a-zA-Z]+)?$',
  );

  // Call super.pure to represent an unmodified form input.
  const FullName.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const FullName.dirty( String value ) : super.dirty(value);

  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == FullNameError.empty ) return 'El campo es requerido';
    if ( displayError == FullNameError.format ) return 'Sólo se permiten letras para el nombre';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  FullNameError? validator(String value) {
    
    if ( value.isEmpty || value.trim().isEmpty ) return FullNameError.empty;
    if ( !emailRegExp.hasMatch(value) ) return FullNameError.format;

    return null;
  }
}