import 'package:formz/formz.dart';

// Define input validation errors
enum CodeError { empty, format }

// Extend FormzInput and provide the input type and error type.
class Code extends FormzInput<String, CodeError> {

  static final RegExp codeRegExp = RegExp(
    r'^[0-9]+$',
  );

  // Call super.pure to represent an unmodified form input.
  const Code.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Code.dirty( String value ) : super.dirty(value);

  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == CodeError.empty ) return 'Requerido';
    if ( displayError == CodeError.format ) return 'Sólo se permiten números';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  CodeError? validator(String value) {
    
    if ( value.isEmpty || value.trim().isEmpty ) return CodeError.empty;
    if ( !codeRegExp.hasMatch(value) ) return CodeError.format;

    return null;
  }
}