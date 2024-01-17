import 'package:authentication_app/shared/inputs/inputs.dart';
import 'package:formz/formz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:authentication_app/presentation/providers/providers.dart';

part 'otp_form_provider.g.dart';

// @Riverpod(keepAlive: true)
@riverpod
class OtpForm extends _$OtpForm {
  
  late Future<bool> Function(String, String) validateCodeCallback;
  late Future<Map<String, dynamic>> Function( String ) validateEmailToRecoveryPasswordCallback;

  late final RecoveryPasswordForm recoverPassProvider;

  @override
  OtpFormStatus build() {

    final authPrvd = ref.read( authProvider.notifier );
    validateCodeCallback = authPrvd.validateCode;
    validateEmailToRecoveryPasswordCallback = authPrvd.validateEmailToPasswordRecovery;

    recoverPassProvider = ref.read( recoveryPasswordFormProvider.notifier );
    
    return OtpFormStatus();
  }


  onDigit1Change( String value ){
    
    final newDigit1 = Code.dirty( value );

    state = state.copyWith(
      isFormPosted: true,
      digit1: newDigit1,
      formStatus: Formz.validate([ newDigit1, state.digit2, state.digit3, state.digit4 ])
        ? OtpFormSubmissionStatus.valid
        : OtpFormSubmissionStatus.notValid
    );
  }

  onDigit2Change( String value ){
    
    final newDigit2 = Code.dirty( value );

    state = state.copyWith(
      isFormPosted: true,
      digit2: newDigit2,
      formStatus: Formz.validate([ state.digit1, newDigit2, state.digit3, state.digit4 ])
        ? OtpFormSubmissionStatus.valid
        : OtpFormSubmissionStatus.notValid
    );
  }

  onDigit3Change( String value ){
    
    final newDigit3 = Code.dirty( value );

    state = state.copyWith(
      isFormPosted: true,
      digit3: newDigit3,
      formStatus: Formz.validate([ state.digit1, state.digit2, newDigit3, state.digit4 ])
        ? OtpFormSubmissionStatus.valid
        : OtpFormSubmissionStatus.notValid
    );
  }

  onDigit4Change( String value ){
    
    final newDigit4 = Code.dirty( value );

    state = state.copyWith(
      isFormPosted: true,
      digit4: newDigit4,
      formStatus: Formz.validate([ state.digit1, state.digit2, state.digit3, newDigit4 ])
        ? OtpFormSubmissionStatus.valid
        : OtpFormSubmissionStatus.notValid
    );
  }

  Future<bool> onResendCode() async {

    state = state.copyWith(
      formStatus: OtpFormSubmissionStatus.resend
    );

    final existsEmail = await validateEmailToRecoveryPasswordCallback( recoverPassProvider.state.email.value );

    state = state.copyWith(
      formStatus: OtpFormSubmissionStatus.initial
    );

    if ( existsEmail.isNotEmpty && existsEmail['resp'] == true ) {

      // print({ 'correoReenviado': existsEmail['token']} );

      // almacenar nuevo token en recoveryPasswordFormProvider
      recoverPassProvider.updateToken( existsEmail['token'] );

      return true;
    }


    return false;


  }

  Future<bool> onFormSubmit() async {

    _touchEveryField();
    if ( state.formStatus == OtpFormSubmissionStatus.notValid ) return false;

    state = state.copyWith(
      formStatus: OtpFormSubmissionStatus.posting
    );

    final verificationCode = '${ state.digit1.value }${ state.digit2.value }${ state.digit3.value }${ state.digit4.value }';

    // realizar petición para verificar código de 4 digitos y enviar token
    
    // print({ 'tokenquerecibebackend' : recoverPassProvider.state.tokenPasswordRecover });

    final resp = await validateCodeCallback( recoverPassProvider.state.tokenPasswordRecover, verificationCode );

    state = state.copyWith(
      formStatus: OtpFormSubmissionStatus.initial
    );

    return resp;

    
  }

  _touchEveryField(){

    final digit1 = Code.dirty( state.digit1.value );
    final digit2 = Code.dirty( state.digit2.value );
    final digit3 = Code.dirty( state.digit3.value );
    final digit4 = Code.dirty( state.digit4.value );

    state = state.copyWith(

      isFormPosted: true,
      digit1: digit1,
      digit2: digit2,
      digit3: digit3,
      digit4: digit4,
      formStatus: Formz.validate([ digit1, digit2, digit3, digit4 ])
        ? OtpFormSubmissionStatus.valid
        : OtpFormSubmissionStatus.notValid
    );

  }

  clearAllFields(){

    const digit1 = Code.dirty('');
    const digit2 = Code.dirty('');
    const digit3 = Code.dirty('');
    const digit4 = Code.dirty('');

    state = state.copyWith(
      isFormPosted: false,
      digit1: digit1,
      digit2: digit2,
      digit3: digit3,
      digit4: digit4,
      formStatus: OtpFormSubmissionStatus.initial
    );

  }
  
}



enum OtpFormSubmissionStatus { initial, notValid, valid, posting, resend }

class OtpFormStatus {

  final OtpFormSubmissionStatus formStatus;

  final Code digit1;
  final Code digit2;
  final Code digit3;
  final Code digit4;

  final bool isFormPosted;

  OtpFormStatus({
    this.formStatus = OtpFormSubmissionStatus.initial,
    this.digit1 = const Code.pure(),
    this.digit2 = const Code.pure(),
    this.digit3 = const Code.pure(),
    this.digit4 = const Code.pure(),
    this.isFormPosted = false,
  });

  OtpFormStatus copyWith({
    OtpFormSubmissionStatus? formStatus,
    Code? digit1,
    Code? digit2,
    Code? digit3,
    Code? digit4,
    bool? isFormPosted,
  }) {
    return OtpFormStatus(
      formStatus: formStatus ?? this.formStatus,
      digit1: digit1 ?? this.digit1,
      digit2: digit2 ?? this.digit2,
      digit3: digit3 ?? this.digit3,
      digit4: digit4 ?? this.digit4,
      isFormPosted: isFormPosted ?? this.isFormPosted,
    );
  }

  @override
  String toString() {
    return '''
    OtpFormStatus:
    digit1: $digit1
    digit2: $digit2
    digit3: $digit3
    digit4: $digit4
    formStatus: $formStatus
    isFormPosted: $isFormPosted
    ''';
  }
}

