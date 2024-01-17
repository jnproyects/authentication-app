import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:authentication_app/presentation/providers/providers.dart';
import 'package:go_router/go_router.dart';


class OtpFormScreen extends ConsumerWidget {
  
  const OtpFormScreen({super.key});

  void showSnackbar( BuildContext context, String errorMessage ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage)
      )
    );
  }

  @override
  Widget build( BuildContext context, WidgetRef ref ) {

    final otpForm = ref.watch( otpFormProvider );
    final countDownCodeP = ref.watch( countDownCodeProvider );

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
          
                const SizedBox( height: 40, ),
          
                const Padding(
                  padding: EdgeInsets.symmetric( horizontal: 15 ),
                  child: Text(
                    'Hemos enviado un código de verificación al correo dxxxxxls@gxxxl.com. Ingrésalo en los campos de abajo.',
                    style: TextStyle(
                      fontSize: 19
                    ),
                  ),
                ),
        
                const SizedBox( height: 10 ),
        
                Container(
                  alignment: Alignment.bottomLeft,
                  child: TextButton( 
                    onPressed: () {
                      context.pushReplacement('/recovery-password');
                    },
                    child: const Text('¿No es tu correo?, cambialo aquí') 
                  ),
                ),
        
                SizedBox( height: size.height * 0.2, ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
        
                    SizedBox(
                      height: 68,
                      width: 64,
                      child: TextFormField(
                        onChanged: ( value ) {
                          ref.read( otpFormProvider.notifier ).onDigit1Change( value );
                          if ( value.length == 1 ) FocusScope.of(context).nextFocus();
                        },
                        style: Theme.of(context).textTheme.headlineSmall,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          errorText: otpForm.isFormPosted ? otpForm.digit1.errorMessage : null
                        ),
                      ),
                    ),
        
                    SizedBox(
                      height: 68,
                      width: 64,
                      child: TextFormField(
                        onChanged: ( value ) {
                          ref.read( otpFormProvider.notifier ).onDigit2Change( value );
                          if ( value.length == 1 ) FocusScope.of(context).nextFocus();
                        },
                        style: Theme.of(context).textTheme.headlineSmall,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          errorText: otpForm.isFormPosted ? otpForm.digit2.errorMessage : null
                        ),
                      ),
                    ),
        
                    SizedBox(
                      height: 68,
                      width: 64,
                      child: TextFormField(
                        onChanged: ( value ) {
                          ref.read( otpFormProvider.notifier ).onDigit3Change( value );
                          if ( value.length == 1 ) FocusScope.of(context).nextFocus();
                        },
                        style: Theme.of(context).textTheme.headlineSmall,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          errorText: otpForm.isFormPosted ? otpForm.digit3.errorMessage : null
                        ),
                      ),
                    ),
        
                    SizedBox(
                      height: 68,
                      width: 64,
                      child: TextFormField(
                        onChanged: ref.read( otpFormProvider.notifier ).onDigit4Change,
                        style: Theme.of(context).textTheme.headlineSmall,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          errorText: otpForm.isFormPosted ? otpForm.digit4.errorMessage : null
                        ),
                      ),
                    ),
                  ]
                ),
        
                const SizedBox( height: 20,  ),
        
        
                countDownCodeP.when(
                  data: (data) {
        
                    if ( data == 0 ) {
        
                      return const Text(
                        'Tu código expiró, debes solicitar uno nuevo.',
                        style: TextStyle(
                          color: Colors.red
                        ),
                      );
        
                    }
                    
                    return Text( data == 1
                      ? 'Código expira en: $data segundo...'
                      : 'Código expira en: $data segundos...'
                    );
        
                  },
                  error: (error, stackTrace) {
                    return Text('$error');
                  },
                  loading: () => const SizedBox(),
                  
                ),
        
                Container(
                  margin: const EdgeInsets.only( top: 50 ),
                  child: FilledButton(
                    onPressed: otpForm.formStatus == OtpFormSubmissionStatus.resend || ( countDownCodeP.hasValue && countDownCodeP.value! > 0  )
                      ? null 
                      : () async {
        
                          final resp = await ref.read( otpFormProvider.notifier ).onResendCode();
        
                          // true -> se generó un nuevo token que se guardo en estado y se envio un nuevo correo
                          if ( resp ){
        
                            // reiniciar contador
                            ref.invalidate( countDownCodeProvider );
                            
                            // limpia el estado pero no refresca los cambios
                            ref.read( otpFormProvider.notifier ).clearAllFields();
        
                          }
                      }, 
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all( Size( size.width * 0.7, 45 ) )  ,
                    ),
                    child: otpForm.formStatus == OtpFormSubmissionStatus.resend && ( countDownCodeP.hasValue && countDownCodeP.value! == 0  )
                      ? const SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator( strokeWidth: 2 )
                      ) 
                      : const Text('Resend code'),
                    // child: const Text('Resend code'),
                  ),
                ),
          
                Container(
                  margin: const EdgeInsets.only( top: 20 ),
                  child: FilledButton(
                    onPressed: otpForm.formStatus != OtpFormSubmissionStatus.valid || ( countDownCodeP.hasValue && countDownCodeP.value! == 0 )
                      ? null
                      : () async {
        
                        final resp = await ref.read( otpFormProvider.notifier ).onFormSubmit();
                        
                        // false -> código no valido
                        if ( !resp ) return showSnackbar( context, 'Código es incorrecto ó ya expiró');
        
                        // true -> codigo ingresado por usuario es válido - enviar a screen cambio contraseña
                        context.pushReplacement('/change-password');
        
                      },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all( Size( size.width * 0.7, 45 ) )  
                    ),
                    child: otpForm.formStatus == OtpFormSubmissionStatus.posting
                      ? const SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator( strokeWidth: 2 )
                      ) 
                      : const Text('Continue'),
                  ),
                ),
        
        
                
          
              ],
            ),
          ),
        ),
      )
    );
    
  }
}

class InputTextCode extends ConsumerWidget {
  const InputTextCode({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 68,
      width: 64,
      child: TextFormField(
        
        onChanged: (value) {
          if ( value.length == 1 ) {
            // FocusScope.of(context).nextFocus();
            // ref.read( otpFormProvider.notifier ).onCodeInputChange( value );
          }
        },
        // decoration: InputDecoration(
        //   hintText: '0'
        // ),
        style: Theme.of(context).textTheme.headlineSmall,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        textAlign: TextAlign.center,
        // validator: (value) {
        //   if ( value == null ) return 'El campo no puede estar vacio';
        // },
      ),
    );
  }
}