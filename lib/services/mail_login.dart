import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../utils/utils.dart';
import 'auth_methods.dart';

class MailSignInModule extends StatefulWidget {
  @override
  _MailSignInModuleState createState() => _MailSignInModuleState();
}

class _MailSignInModuleState extends State<MailSignInModule> {

  final TextEditingController _emailIdController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  bool _isLoading = false;

  var _textStyleBlack = new TextStyle(fontSize: 12.0, color: Colors.black);


  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: new TextField(
              controller: _emailIdController,
              decoration: new InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.6),
                  hintText: 'Email',
                  border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.black),
                  ),
                  isDense: true),
              style: _textStyleBlack,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.6),
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  isDense: true),
              style: _textStyleBlack,
            ),
          ),
          GestureDetector(
            onTap: _logInUser,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10.0),
              width: 500.0,
              height: 40.0,
              child: _isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  color: Colors.lightBlueAccent,
                ),
              )
                  : Text(
                "Log In",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            ),
          )
        ]
    );
  }

  void _logInUser() async {
    if (_emailIdController.text.isEmpty) {
      showEmptyDialog("Il campo mail", context);
    } else if (_passwordController.text.isEmpty) {
      showEmptyDialog("Il campo password", context);
    }
    setState(() {
      _isLoading = true;
    });
    String result = await Authentication().logInUser(
      email: _emailIdController.text,
      password: _passwordController.text,
    );
    if (result == 'success') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    } else {
      showSnackBar(result, context);
    }
    setState(() {
      _isLoading = false;
    });
  }
}
