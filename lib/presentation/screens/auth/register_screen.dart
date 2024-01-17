import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:authentication_app/presentation/widgets/widgets.dart';
import 'package:authentication_app/presentation/providers/providers.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  // void showRegisterSnackbar( BuildContext context, String errorMessage ) {
  //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(errorMessage)
  //     )
  //   );
  // }


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final registerForm = ref.watch( registerFormProvider );

    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;
    
    // ref.listen( authProvider, (previous, next) {
    //   if ( next.errorMessage.isEmpty ) return;
    //   showRegisterSnackbar( context, next.errorMessage );
    // });

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                        
                Text(
                  'Sign Up',
                  style: textStyles.titleSmall,
                ),
                        
                const SizedBox( height: 50 ),

                CustomTextFormField(
                  label: 'Full Name',
                  readOnly: registerForm.formStatus == RegisterFormSubmissionStatus.posting ? true: false,
                  onChanged: ref.read( registerFormProvider.notifier ).onFullNameChange,
                  errorMessage: registerForm.isFormPosted ? registerForm.fullName.errorMessage : null,
                ),
            
                const SizedBox( height: 20 ),

                CustomTextFormField(
                  label: 'Email',
                  readOnly: registerForm.formStatus == RegisterFormSubmissionStatus.posting ? true: false,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: ref.read( registerFormProvider.notifier ).onEmailChange,
                  errorMessage: registerForm.isFormPosted ? registerForm.email.errorMessage : null,
                ),
                        
                const SizedBox( height: 20 ),
                
                CustomTextFormField(
                  label: 'Password',
                  readOnly: registerForm.formStatus == RegisterFormSubmissionStatus.posting ? true: false,
                  obscureText: true,
                  onChanged: ref.read( registerFormProvider.notifier ).onPasswordChange,
                  errorMessage: registerForm.isFormPosted ? registerForm.password.errorMessage : null,
                ),

                const SizedBox( height: 20 ),

                CustomTextFormField(
                  label: 'Confirm Password',
                  readOnly: registerForm.formStatus == RegisterFormSubmissionStatus.posting ? true: false,
                  obscureText: true,
                  onChanged: ref.read( registerFormProvider.notifier ).onConfirmedPasswordChange,
                  errorMessage: registerForm.isFormPosted ? registerForm.confirmedPassword.errorMessage : null,
                ),

                Container(
                  margin: const EdgeInsets.only( top: 50 ),
                  child: FilledButton(
                    onPressed: registerForm.formStatus == RegisterFormSubmissionStatus.posting
                      ? null
                      : ref.read( registerFormProvider.notifier ).onFormSubmit, 
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all( Size( size.width * 0.7, 45 ) )  
                    ),
                    child:  registerForm.formStatus == RegisterFormSubmissionStatus.posting
                      ? const SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator( strokeWidth: 2 )
                        )
                      : const Text(
                        'Register',
                      ),
                  ),
                ),
                
                const SizedBox( height: 40 ),
                        
                const Text('Or login with'),
                        
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    IconButton.outlined(onPressed: (){}, icon: const Icon( Icons.facebook ) ),
                    IconButton.outlined(onPressed: (){}, icon: const Icon( Icons.mail_lock_rounded ) ),
                    IconButton.outlined(onPressed: (){}, icon: const Icon( Icons.add_moderator ) ),
                  ],
                ),
                        
                const Divider(
                  indent: 25,
                  endIndent: 25,
                ),
                        
                const SizedBox( height: 10 ),
                        
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Do you have an account?"),
                    TextButton(
                      onPressed: () {
                        if ( context.canPop() ){
                          return context.pop();
                        }
                        context.go('/login');

                      }, 
                      child: const Text('Login here')
                    )
                  ],
                )
                        
              ],
            ),
          ),
        ),
      ),
    );
  }
  
}