import 'package:formz/formz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:authentication_app/presentation/providers/providers.dart';
import 'package:authentication_app/shared/inputs/inputs.dart';

part 'recovery_password_provider.g.dart';

enum RecoveryPasswordFormSubmissionStatus { initial, notValid, valid, posting }

class RecoveryPasswordFormState {

  final RecoveryPasswordFormSubmissionStatus formStatus;
  final bool isFormPosted;
  final Email email;
  final String tokenPasswordRecover;

  RecoveryPasswordFormState({
    this.formStatus = RecoveryPasswordFormSubmissionStatus.initial,
    this.isFormPosted = false,
    this.email = const Email.pure(),
    this.tokenPasswordRecover = ''
  });

  RecoveryPasswordFormState copyWith({
    RecoveryPasswordFormSubmissionStatus? formStatus,
    bool? isFormPosted,
    Email? email,
    String? tokenPasswordRecover,
  }) => RecoveryPasswordFormState(
    formStatus: formStatus ?? this.formStatus,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    email: email ?? this.email,
    tokenPasswordRecover: tokenPasswordRecover ?? this.tokenPasswordRecover,
  );

  @override
  String toString() {
    return '''
    RecoveryPasswordFormState:
    formStatus: $formStatus
    isFormPosted: $isFormPosted
    email: $email
    tokenPassRecover: $tokenPasswordRecover
    ''';
  }

}


// @riverpod
@Riverpod( keepAlive: true )
class RecoveryPasswordForm extends _$RecoveryPasswordForm {

  late Future<Map<String, dynamic>> Function( String ) validateEmailToRecoveryPasswordCallback;
  
  @override
  RecoveryPasswordFormState build() {
    validateEmailToRecoveryPasswordCallback = ref.read( authProvider.notifier ).validateEmailToPasswordRecovery;
    return RecoveryPasswordFormState();
  }

  onEmailChange( String value ){
    final newEmail = Email.dirty( value );
    state = state.copyWith(
      isFormPosted: true,
      email: newEmail,
      formStatus: Formz.validate([ newEmail ])
        ? RecoveryPasswordFormSubmissionStatus.valid
        : RecoveryPasswordFormSubmissionStatus.notValid,
    );
  }

  updateToken( String newToken ){
    state = state.copyWith(
      tokenPasswordRecover: newToken
    );
  }

  Future<bool> onFormSubmit() async {

    _touchEveryField();
    if ( state.formStatus == RecoveryPasswordFormSubmissionStatus.notValid ) return false;

    state = state.copyWith(
      formStatus: RecoveryPasswordFormSubmissionStatus.posting
    );

    final existsEmail = await validateEmailToRecoveryPasswordCallback( state.email.value );

    // ACA RECIBIR ID DE USUARIO Y GUARDAR EN ESTADO

    state = state.copyWith(
      formStatus: RecoveryPasswordFormSubmissionStatus.initial,
    );

    if ( existsEmail.isNotEmpty && existsEmail['resp'] == true ) {

      print({ 'pirmercorreo': existsEmail['token']} );

      
      // guardar token en el estado
      state = state.copyWith(
        tokenPasswordRecover: existsEmail['token']
      );

      return true;

    }

    return false;
    
  }

  _touchEveryField() {

    final email = Email.dirty( state.email.value );

    state = state.copyWith(
      email: email,
      isFormPosted: true,
      formStatus: Formz.validate([ email ]) 
        ? RecoveryPasswordFormSubmissionStatus.valid
        : RecoveryPasswordFormSubmissionStatus.notValid
    );

  }

}