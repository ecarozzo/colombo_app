import 'dart:async';

import 'package:colombo_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

import '../constant/screen_name.dart';

class Authentication {
  StreamController<SessionState> sessionStateStream;

  Authentication({Key? key, required this.sessionStateStream});

  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.pushNamed(context, homeScreenRoute);
    }
    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            showSnackBar(
                'The account already exists with a different credential',
                context);
          } else if (e.code == 'invalid-credential') {
            showSnackBar(
                'Error occurred while accessing credentials. Try again.',
                context);
          }
        } catch (e) {
          showSnackBar(
              'Error occurred using Google Sign In. Try again.', context);
        }
      }
      return user;
    }
    return null;
  }

  Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      if (FirebaseAuth.instance.currentUser != null) {
        sessionStateStream.add(SessionState.stopListening);
        await FirebaseAuth.instance.signOut();
      }
    } catch (e) {
      showSnackBar('Errore di Logout.', context);
    }
  }

  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String result = 'Errore di Login.';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        result = 'success';
      }
    } catch (err) {
      result = err.toString();
    }
    return result;
  }
}
