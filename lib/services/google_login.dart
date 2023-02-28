import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import '../constant/screen_name.dart';
import 'auth_methods.dart';

class GoogleSignInButton extends StatefulWidget {
  final StreamController<SessionState> sessionStateStream;
  const GoogleSignInButton({Key? key, required this.sessionStateStream}) : super(key: key);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
      )
          :
      SignInButton(
        Buttons.Google,
        onPressed: () async {
          setState(() {
            _isSigningIn = true;
          });

          User? user =
          await Authentication.signInWithGoogle(context: context);

          setState(() {
            _isSigningIn = false;
          });

          if (user != null) {
            widget.sessionStateStream.add(SessionState.startListening);
            Navigator.pushNamed(context, homeScreenRoute);
          }
        },
      ),
    );
  }
}