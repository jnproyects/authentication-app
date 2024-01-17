
import 'package:formz/formz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:authentication_app/presentation/providers/providers.dart';
import 'package:authentication_app/shared/inputs/inputs.dart';

part 'register_form_provider.g.dart';

enum RegisterFormSubmissionStatus { initial, valid, notValid, posting }

class RegisterFormState {

  final RegisterFormSubmissionStatus formStatus;
  final bool isFormPosted;
  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final FullName fullName;

  RegisterFormState({
    this.formStatus = RegisterFormSubmissionStatus.initial,
    this.isFormPosted = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.fullName = const FullName.pure(),
  });

  RegisterFormState copyWith({
    RegisterFormSubmissionStatus? formStatus,
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    FullName? fullName,
  }) => RegisterFormState(
    formStatus: formStatus ?? this.formStatus,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    email: email ?? this.email,
    password: password ?? this.password,
    confirmedPassword: confirmedPassword ?? this.confirmedPassword,
    fullName: fullName ?? this.fullName,
  );

  @override
  String toString() {
    return '''
      RegisterFormState:
      formStatus: $formStatus
      isFormPosted: $isFormPosted
      email: $email
      password: $password
      fullName: $fullName
    ''';
  }

}


@riverpod
class RegisterForm extends _$RegisterForm {

  late Function(String, String, String) registerUserCallback;

  @override
  RegisterFormState build() {
    registerUserCallback = ref.read( authProvider.notifier ).registerUser;
    return RegisterFormState();
  }

  onFullNameChange( String value ) {
    final newFullName = FullName.dirty( value );
    state = state.copyWith(
      isFormPosted: true,
      fullName: newFullName,
      formStatus: Formz.validate([ newFullName, state.email, state.password, state.confirmedPassword ])
        ? RegisterFormSubmissionStatus.valid
        : RegisterFormSubmissionStatus.notValid
    );
  }

  onEmailChange( String value ) {
    final newEmail = Email.dirty( value );
    state = state.copyWith(
      isFormPosted: true,
      email: newEmail,
      formStatus: Formz.validate([ newEmail, state.fullName, state.password, state.confirmedPassword ])
        ? RegisterFormSubmissionStatus.valid
        : RegisterFormSubmissionStatus.notValid
    );
  }

  onPasswordChange( String value ) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      isFormPosted: true,
      password: newPassword,
      formStatus: Formz.validate([ newPassword, state.email, state.fullName, state.confirmedPassword ])
        ? RegisterFormSubmissionStatus.valid
        : RegisterFormSubmissionStatus.notValid
    );
  }

  onConfirmedPasswordChange( String value ) {
    final newConfirmedPassword = ConfirmedPassword.dirty( password: state.password.value, value: value );
    state = state.copyWith(
      isFormPosted: true,
      confirmedPassword: newConfirmedPassword,
      formStatus: Formz.validate([ newConfirmedPassword, state.password, state.email, state.fullName ])
        ? RegisterFormSubmissionStatus.valid
        : RegisterFormSubmissionStatus.notValid
    );
  }

  onFormSubmit() async {

    _touchEveryField();
    if ( state.formStatus == RegisterFormSubmissionStatus.notValid ) return;

    state = state.copyWith(
      formStatus: RegisterFormSubmissionStatus.posting
    );

    await registerUserCallback( state.fullName.value, state.email.value, state.password.value );

    state = state.copyWith(
      formStatus: RegisterFormSubmissionStatus.initial
    );

  }

  _touchEveryField() {

    final fullName = FullName.dirty( state.fullName.value );
    final email = Email.dirty( state.email.value );
    final password = Password.dirty( state.password.value );
    final confirmedPassword = ConfirmedPassword.dirty( password: state.password.value, value: state.confirmedPassword.value );

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      fullName: fullName,
      confirmedPassword: confirmedPassword,
      formStatus: Formz.validate([ email, password, confirmedPassword, fullName ])
        ? RegisterFormSubmissionStatus.valid
        : RegisterFormSubmissionStatus.notValid
    );
  }


}

