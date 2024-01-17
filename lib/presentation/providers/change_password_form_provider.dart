// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:authentication_app/presentation/providers/providers.dart';
import 'package:formz/formz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:authentication_app/shared/inputs/inputs.dart';

part 'change_password_form_provider.g.dart';



enum ChangePasswordFormSubmissionStatus { initial, notValid, valid, posting }

class ChangePasswordFormState {

  final ChangePasswordFormSubmissionStatus formStatus;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final bool isFormPosted;

  ChangePasswordFormState({
    this.formStatus = ChangePasswordFormSubmissionStatus.initial,
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.isFormPosted = false,
  });

  ChangePasswordFormState copyWith({
    ChangePasswordFormSubmissionStatus? formStatus,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    bool? isFormPosted,
  }) {
    return ChangePasswordFormState(
      formStatus: formStatus ?? this.formStatus,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      isFormPosted: isFormPosted ?? this.isFormPosted,
    );
  }

  @override
  String toString() => '''
  ChangePasswordFormState:
  formStatus: $formStatus
  password: $password
  confirmedPassword: $confirmedPassword
  isFormPosted: $isFormPosted  
  ''';

}



@riverpod
class ChangePasswordForm extends _$ChangePasswordForm {

  late Future<bool> Function(String, String) changePasswordCallback;

  late final RecoveryPasswordFormState recoverPassProvider; 

  @override
  ChangePasswordFormState build() {

    changePasswordCallback = ref.read( authProvider.notifier ).changePassword;

    recoverPassProvider = ref.read( recoveryPasswordFormProvider );
    return ChangePasswordFormState();
  }

  onPasswordChange( String value ) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      isFormPosted: true,
      password: newPassword,
      formStatus: Formz.validate([ newPassword, state.confirmedPassword ])
        ? ChangePasswordFormSubmissionStatus.valid
        : ChangePasswordFormSubmissionStatus.notValid
    );
  }

  onConfirmedPasswordChange( String value ) {
    final newConfirmedPassword = ConfirmedPassword.dirty( password: state.password.value, value: value );
    state = state.copyWith(
      isFormPosted: true,
      confirmedPassword: newConfirmedPassword,
      formStatus: Formz.validate([ state.password, newConfirmedPassword ])
        ? ChangePasswordFormSubmissionStatus.valid
        : ChangePasswordFormSubmissionStatus.notValid
    );
  }

  Future<bool> onFormSubmit() async {

    _touchEveryField();
    if( state.formStatus == ChangePasswordFormSubmissionStatus.notValid ) return false;

    state = state.copyWith(
      formStatus: ChangePasswordFormSubmissionStatus.posting
    );

    final resp = await changePasswordCallback( recoverPassProvider.email.value, state.password.value );

    print({ 'respcambiopass: $resp' });

    state = state.copyWith(
      formStatus: ChangePasswordFormSubmissionStatus.initial
    );

    return true;
  }


  _touchEveryField() {

    final password = Password.dirty( state.password.value );
    final confirmedPassword = ConfirmedPassword.dirty( password: state.password.value, value: state.confirmedPassword.value );


    state = state.copyWith(
      isFormPosted: true,
      password: password,
      confirmedPassword: confirmedPassword,
      formStatus: Formz.validate([ password, confirmedPassword ])
        ? ChangePasswordFormSubmissionStatus.valid
        : ChangePasswordFormSubmissionStatus.notValid
    );


  }


}
