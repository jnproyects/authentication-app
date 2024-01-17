
import 'package:formz/formz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:authentication_app/presentation/providers/providers.dart';
import 'package:authentication_app/shared/inputs/inputs.dart';

part 'login_form_provider.g.dart';


enum LoginFormSubmissionStatus { initial, valid, notValid, posting }

class LoginFormState {

  final LoginFormSubmissionStatus formStatus;
  final bool isFormPosted;
  final Email email;
  final Password password;

  LoginFormState({
    this.formStatus = LoginFormSubmissionStatus.initial,
    this.isFormPosted = false, 
    this.email = const Email.pure(), 
    this.password = const Password.pure()
  });

  LoginFormState copyWith({
    LoginFormSubmissionStatus? formStatus,
    bool? isFormPosted,
    Email? email,
    Password? password
  }) => LoginFormState(
    formStatus: formStatus ?? this.formStatus,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    email: email ?? this.email,
    password: password ?? this.password,
  );


  @override
  String toString() {
    return '''
    LoginFormState:
    isFormPosted: $isFormPosted
    email: $email
    password: $password
    formStatus: $formStatus
    ''';
  }
}

@riverpod
class LoginForm extends _$LoginForm {

  late Future<bool> Function( String, String ) loginUserCallback;

  @override
  LoginFormState build() {
    loginUserCallback = ref.read( authProvider.notifier ).loginUser;
    return LoginFormState();
  }

  onEmailChange( String value ){
    final newEmail = Email.dirty( value );
    state = state.copyWith(
      isFormPosted: true,
      email: newEmail,
      formStatus: Formz.validate([ newEmail, state.password ]) 
        ? LoginFormSubmissionStatus.valid
        : LoginFormSubmissionStatus.notValid,
    );
  }

  onPasswordChange( String value ){
    final newPassword = Password.dirty( value );
    state = state.copyWith(
      isFormPosted: true,
      password: newPassword,
      formStatus: Formz.validate([ newPassword, state.email ]) 
        ? LoginFormSubmissionStatus.valid
        : LoginFormSubmissionStatus.notValid,
    );
  }

  Future<bool> onFormSubmit() async {

    _touchEveryField();

    // si el form no es valido no continua
    if( state.formStatus == LoginFormSubmissionStatus.notValid ) return false;

    // aca el form ya esta validado
    state = state.copyWith(
      formStatus: LoginFormSubmissionStatus.posting,
    );

    // se envia la data a la DB para realizar el login
    final resp = await loginUserCallback( state.email.value, state.password.value );

    state = state.copyWith(
      formStatus: LoginFormSubmissionStatus.initial
    );

    return resp;

  }

  _touchEveryField() {

    final email = Email.dirty( state.email.value );
    final password = Password.dirty( state.password.value );

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      formStatus: Formz.validate([ email, password ]) 
        ? LoginFormSubmissionStatus.valid 
        : LoginFormSubmissionStatus.notValid,
    );

  }

}

