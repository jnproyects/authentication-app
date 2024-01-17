import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:authentication_app/presentation/providers/providers.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build( BuildContext context, WidgetRef ref ) {
    
    // final user = ref.watch( authProvider.select(
    //   (state) => state.user )
    // );

    final user = ref.watch( authProvider ).user;

    final textStyles = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication App'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const FlutterLogo(
              size: 150,
            ),

            const SizedBox( height: 30,),
            

            Text('Welcome ${ user!.fullName }', style: textStyles.titleSmall),

            const SizedBox( height: 25,),

            FilledButton(
              onPressed: ref.read( authProvider.notifier ).logout, 
              child: const Text('Logout')
            )
          ],
        )
      ),
    );

  }
}