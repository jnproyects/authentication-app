import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:authentication_app/presentation/providers/providers.dart';
import 'package:authentication_app/presentation/widgets/widgets.dart';
import 'package:go_router/go_router.dart';


class ChangePasswordScreen extends ConsumerWidget {
  
  const ChangePasswordScreen({super.key});

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

    final changePassFormProv = ref.watch( changePasswordFormProvider );

    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Authentication App'),
      // ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [

                BackButton(
                  onPressed: (){},
                  style: ButtonStyle(
                    iconSize:  MaterialStateProperty.all( 35 ),
                  ),
                ),
        
                Container(
                  margin: EdgeInsets.only( top: 50 ),
                  child: Text(
                    'Ingresa tu nueva contraseña',
                    style: textStyles.headlineSmall
                  ),
                ),
        
                const SizedBox( height: 50 ),
        
                CustomTextFormField(
                  label: 'Password',
                  readOnly: changePassFormProv.formStatus == ChangePasswordFormSubmissionStatus.posting ? true: false,
                  obscureText: true,
                  onChanged: ref.read( changePasswordFormProvider.notifier ).onPasswordChange,
                  errorMessage: changePassFormProv.isFormPosted ? changePassFormProv.password.errorMessage : null,
                ),
        
                const SizedBox( height: 30 ),
        
                CustomTextFormField(
                  label: 'Confirm Password',
                  readOnly: changePassFormProv.formStatus == ChangePasswordFormSubmissionStatus.posting ? true: false,
                  obscureText: true,
                  onChanged: ref.read( changePasswordFormProvider.notifier ).onConfirmedPasswordChange,
                  errorMessage: changePassFormProv.isFormPosted ? changePassFormProv.confirmedPassword.errorMessage : null,
                ),
        
        
                Container(
                  margin: const EdgeInsets.only( top: 50 ),
                  child: FilledButton(
                    onPressed: changePassFormProv.formStatus != ChangePasswordFormSubmissionStatus.valid
                      ? null
                      : () async {
                        
                        
                        final resp = await ref.read( changePasswordFormProvider.notifier ).onFormSubmit();
        
                        if ( !resp ) return showSnackbar(context, 'Error al cambiar la contraseña');
        
                        // true -> enviar al user al home y mostrar snackbar de confirmación de cambio
                        context.pop('/');
        
        
        
                      }, 
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all( Size( size.width * 0.7, 45 ) )  
                    ),
                    child:  changePassFormProv.formStatus == ChangePasswordFormSubmissionStatus.posting
                      ? const SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator( strokeWidth: 2 )
                        )
                      : const Text(
                        'Change Password',
                      ),
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