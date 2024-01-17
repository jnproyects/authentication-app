import 'package:flutter/foundation.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:authentication_app/presentation/providers/providers.dart';


part 'app_router_notifier.g.dart';


@Riverpod(keepAlive: true)
GoRouterNotifier goRouterNotifier( GoRouterNotifierRef ref ) {

  final authNotifier = ref.read( authProvider.notifier );
  return GoRouterNotifier( authNotifier, ref );

}


// cuando el status cambia aqui se va a notificar al GoRouter para reevaluar el 'redirect'
class GoRouterNotifier extends ChangeNotifier {

  // instancia que controla el estado de la autenticación
  final Auth _authNotifier;
  AuthStatus _authStatus = AuthStatus.checking;

  // final NotifierProviderRef<AuthState> ref;
  final ProviderRef<GoRouterNotifier> ref;

  GoRouterNotifier( this._authNotifier, this.ref ){
  // GoRouterNotifier( this.ref ){

    // estar pendiente de los cambios que el authNotifier va a ir teniendo
    // para esto creamos el listener para reaccionar a ese nuevo estado

    // opción 1.
    // _authNotifier.ref.listenSelf( ( AuthState? previous, AuthState next ) {
    //   authStatus = next.authStatus;
    // });

    // opción 2. recomendada
    ref.listen( authProvider, (AuthState? previous, AuthState next) {
      authStatus = next.authStatus;
    });
    
  }

  AuthStatus get authStatus => _authStatus;

  set authStatus( AuthStatus value ){
    _authStatus = value;
    notifyListeners();
  }

}