import 'dart:async';

import 'package:colombo_app/screens/home_screen.dart';
import 'package:colombo_app/screens/signup_screen.dart';
import 'package:colombo_app/services/auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:page_transition/page_transition.dart';

import 'constant/screen_name.dart';
import 'screens/signin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  runApp(MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  final sessionStateStream = StreamController<SessionState>();

  @override
  Widget build(BuildContext context) {
    final sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus: const Duration(seconds: 60),
      invalidateSessionForUserInactivity: const Duration(seconds: 60),
    );
    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
      // stop listening, as user will already be in auth page
      sessionStateStream.add(SessionState.stopListening);
      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
        Authentication(sessionStateStream: sessionStateStream).signOut(context: context).then((value) => {
              _navigator.push(PageTransition(
                child: SignInScreen(
                    sessionStateStream: sessionStateStream, loggedOutReason: "Scollegato per inattività"),
                type: PageTransitionType.leftToRight,
              ))
            });
      } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
        Authentication(sessionStateStream: sessionStateStream).signOut(context: context).then((value) => {
              _navigator.push(PageTransition(
                child: SignInScreen(
                    sessionStateStream: sessionStateStream, loggedOutReason: "Scollegato per inattività"),
                type: PageTransitionType.leftToRight,
              ))
            });
      }
    });

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });

    return SessionTimeoutManager(
      userActivityDebounceDuration: const Duration(seconds: 1),
      sessionConfig: sessionConfig,
      sessionStateStream: sessionStateStream.stream,
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Stabilimento Colombo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: signInScreenRoute,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case signInScreenRoute:
              return PageTransition(
                child: SignInScreen(sessionStateStream: sessionStateStream),
                type: PageTransitionType.leftToRight,
                settings: settings,
              );
            case signUpScreenRoute:
              return PageTransition(
                child: SignUpScreen(),
                type: PageTransitionType.leftToRight,
                settings: settings,
              );
            case homeScreenRoute:
              return PageTransition(
                child: HomeScreen(sessionStateStream: sessionStateStream),
                type: PageTransitionType.leftToRight,
                settings: settings,
              );
            default:
              return null;
          }
        },
      ),
    );

    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Stabilimento Colombo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   initialRoute: signInScreenRoute,
    //   onGenerateRoute: (settings) {
    //     switch (settings.name) {
    //       case signInScreenRoute:
    //         return PageTransition(
    //           child: SignInScreen(),
    //           type: PageTransitionType.leftToRight,
    //           settings: settings,
    //         );
    //       case signUpScreenRoute:
    //         return PageTransition(
    //           child: SignUpScreen(),
    //           type: PageTransitionType.leftToRight,
    //           settings: settings,
    //         );
    //       case homeScreenRoute:
    //         return PageTransition(
    //           child: HomeScreen(sessionStream: sessionStateStream),
    //           type: PageTransitionType.leftToRight,
    //           settings: settings,
    //         );
    //       default:
    //         return null;
    //     }
    //   },
    // );
  }
}
