import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:authentication_app/presentation/providers/providers.dart';
import 'package:authentication_app/presentation/screens/screens.dart';

import 'app_router_notifier.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter( GoRouterRef ref) {
  
  final goRouterNotifier = ref.read( goRouterNotifierProvider );

  return GoRouter(
  
    // initialLocation: '/otp',
    initialLocation: '/check-auth',
    refreshListenable: goRouterNotifier,
    routes: [
      
      //* First Route
      GoRoute(
        path: '/check-auth',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      //* Shared Routes - extraido de stackoverflow
      // GoRoute(
      //     path: '/main/:page',
      //     builder: (context, state) {
      //       final pageIndex = state.pathParameters['page'] ?? '0';
      //       return MainScreen(pageIndex: int.parse(pageIndex));
      //     }),

      // GoRoute(
      //   path: '/settings',
      //   builder: (context, state) => const SettingdScreen(),
      // ),

      //* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: '/recovery-password',
        builder: (context, state) => const RecoveryPasswordScreen(),
      ),

      GoRoute(
        path: '/otp',
        builder: (context, state) => const OtpFormScreen(),
      ),

      GoRoute(
        path: '/change-password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),

      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      //* Home Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),

    ],
    redirect: (context, state) { // tpmado de stackoverflow

      // print( state );
      // print(state.matchedLocation);

      final isGoingTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

      if ( isGoingTo == '/check-auth' && authStatus == AuthStatus.checking ) return null;

      if ( authStatus == AuthStatus.notAuthenticated ) {
        
        if( isGoingTo == '/login' || isGoingTo == '/register' || isGoingTo == '/recovery-password' || isGoingTo == '/otp' || isGoingTo == '/change-password' ) return null;

        return '/login';

      }

      if ( authStatus == AuthStatus.authenticated ) {
        if( isGoingTo == '/login' || isGoingTo == '/register' || isGoingTo == '/check-auth' || isGoingTo == '/recovery-password' || isGoingTo == '/change-password' ) return '/';  //return '/main/0'; stak
      }

      // para manejar las rutas permitidas por roles
      // if ( user.isAdmin ){}
      return null;
    },

  );

}