import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:authentication_app/presentation/providers/providers.dart';
import 'package:authentication_app/presentation/widgets/widgets.dart';


class LoginScreen extends ConsumerWidget {

  const LoginScreen({super.key});

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

    final loginForm = ref.watch( loginFormProvider );

    final size = MediaQuery.of(context).size;

    final textStyles = Theme.of( context ).textTheme;

    ref.listen( authProvider, (previous, next) {
      if ( next.errorMessage.isEmpty ) return;
      // ref.invalidate( loginFormProvider );
      
      showSnackbar( context, next.errorMessage );
      
    });

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
                  'Sign In',
                  style: textStyles.titleSmall,
                ),
                        
                const SizedBox( height: 50 ),
            
                CustomTextFormField(
                  label: 'Email',
                  readOnly: loginForm.formStatus == LoginFormSubmissionStatus.posting ? true: false,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: ref.read( loginFormProvider.notifier ).onEmailChange,
                  errorMessage: loginForm.isFormPosted ? loginForm.email.errorMessage : null,
                ),
            
                const SizedBox( height: 20 ),
            
                CustomTextFormField(
                  label: 'Password',
                  readOnly: loginForm.formStatus == LoginFormSubmissionStatus.posting ? true: false,
                  obscureText: true,
                  onChanged: ref.read( loginFormProvider.notifier ).onPasswordChange,
                  onFieldSubmitted: ( _ ) => ref.read( loginFormProvider.notifier ).onFormSubmit(),
                  errorMessage: loginForm.isFormPosted ? loginForm.password.errorMessage : null,
                ),
                        
                Container(
                  margin: const EdgeInsets.only( top: 50 ),
                  child: FilledButton(
                    onPressed: 
                    loginForm.formStatus == LoginFormSubmissionStatus.posting
                      ? null
                      : 
                      () async {

                        final res = await ref.read( loginFormProvider.notifier ).onFormSubmit();

                        // false ->  credenciales inválidas o error que viene desde el server
                        // if ( !res ) return showSnackbar(context, 'Credenciales inválidas');

                        // true
                        if( res ) return showSnackbar(context, 'Bienvenido');


                      },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all( Size( size.width * 0.7, 45 ) )  
                    ),
                    child: 
                    loginForm.formStatus == LoginFormSubmissionStatus.posting
                      ? const SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator( strokeWidth: 2 )
                      ) 
                      : 
                      const Text('Login'),
                  ),
                ),
                        
                const SizedBox( height: 5 ),
                        
                TextButton(
                  onPressed: (){
                    context.push('/recovery-password');
                  },
                  child: const Text('Forgot your password?')
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
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        
                        // ref.read( loginFormProvider.notifier ).clearFields();
                        
                        context.push('/register');
            
                      },
                      child: const Text('Register here')
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
