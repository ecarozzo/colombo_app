import 'dart:async';

import 'package:colombo_app/services/mail_login.dart';
import 'package:flutter/material.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

import '../constant/screen_name.dart';
import '../services/auth_methods.dart';
import '../services/google_login.dart';
import '../utils/utils.dart';

class SignInScreen extends StatefulWidget {
  final StreamController<SessionState> sessionStateStream;
  final String loggedOutReason;

  const SignInScreen({
    Key? key,
    required this.sessionStateStream,
    this.loggedOutReason = "",
  }) : super(key: key);

  @override
  _SignInScreenState createState() => new _SignInScreenState(loggedOutReason);
}

class _SignInScreenState extends State<SignInScreen> {
  _SignInScreenState(String loggedOutReason) {
    if (loggedOutReason != "") {
      scheduleMicrotask(() => showSnackBar(widget.loggedOutReason, context));
    }
  }

  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _textStyleGrey = const TextStyle(fontSize: 12.0, color: Colors.grey);

  @override
  void dispose() {
    super.dispose();
    _emailIdController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: _body(),
          bottomNavigationBar: _bottomBar(),
        ));
  }

  Widget _body() {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/sfondo_login.jpg"),
            fit: BoxFit.cover),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Spacer(flex: 5),
          FutureBuilder(
            future: Authentication.initializeFirebase(context: context),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Errore collegamento database');
              } else if (snapshot.connectionState == ConnectionState.done) {
                return MailSignInModule(
                    sessionStateStream: widget.sessionStateStream);
              }
              return const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.lightBlue,
                ),
              );
            },
          ),
          Spacer(flex: 1),
          FutureBuilder(
            future: Authentication.initializeFirebase(context: context),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Errore collegamento database');
              } else if (snapshot.connectionState == ConnectionState.done) {
                return GoogleSignInButton(
                    sessionStateStream: widget.sessionStateStream);
              }
              return CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.lightBlue,
                ),
              );
            },
          ),
          Spacer(flex: 4),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      alignment: Alignment.center,
      height: 49.5,
      child: Column(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 1.0,
                color: Colors.grey.withOpacity(0.7),
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: 0.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Non sei registrato?", style: _textStyleGrey),
                      Container(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, signUpScreenRoute);
                          },
                          child: Text('Tocca qui.', style: _textStyleGrey),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
