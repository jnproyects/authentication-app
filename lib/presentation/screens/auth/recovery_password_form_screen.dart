import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:authentication_app/presentation/providers/providers.dart';
import 'package:authentication_app/presentation/widgets/widgets.dart';


class RecoveryPasswordScreen extends ConsumerWidget {
  
  const RecoveryPasswordScreen({super.key});

  void showSnackbar( BuildContext context, String errorMessage ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage)
      )
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref ) {

    final textStyles = Theme.of(context).textTheme;

    final recoveryPasswordForm = ref.watch( recoveryPasswordFormProvider );

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication App'),
        centerTitle: true,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                
                Text(
                  'Recover your password',
                  style: textStyles.titleSmall,
                ),
                        
                const SizedBox( height: 50 ),

                CustomTextFormField(
                  label: 'Email',
                  readOnly: recoveryPasswordForm.formStatus == RecoveryPasswordFormSubmissionStatus.posting ? true: false,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: ref.read( recoveryPasswordFormProvider.notifier ).onEmailChange,
                  errorMessage: recoveryPasswordForm.isFormPosted ? recoveryPasswordForm.email.errorMessage : null,
                ),

                Container(
                  margin: const EdgeInsets.only( top: 50 ),
                  child: FilledButton(
                    onPressed: recoveryPasswordForm.formStatus != RecoveryPasswordFormSubmissionStatus.valid
                      ? null
                      : () async {
                        
                        // aca tiene que llegar si correo existe o no
                        final bool resp = await ref.read( recoveryPasswordFormProvider.notifier ).onFormSubmit();

                        // false -> mostrar snackbar de correo no existe
                        if ( !resp ) return showSnackbar( context, 'Correo no está registrado en nuestro sistema.');
                        
                        // true -> ir a pantalla OTP para ingreso de código
                        context.pushReplacement('/otp');

                      }, 
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all( Size( size.width * 0.7, 45 ) )  
                    ),
                    child: recoveryPasswordForm.formStatus == RecoveryPasswordFormSubmissionStatus.posting
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
      ),
    );
  }


}