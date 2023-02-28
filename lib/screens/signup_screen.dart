import 'package:colombo_app/constant/screen_name.dart';
import 'package:colombo_app/services/signup_methods.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailIdController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _nomeController = new TextEditingController();
  final TextEditingController _cognomeController = new TextEditingController();
  final TextEditingController _telefonoController = new TextEditingController();
  final TextEditingController _indirizzoController = new TextEditingController();

  var _textStyleBlack = new TextStyle(fontSize: 12.0, color: Colors.black);
  var _textStyleGrey = new TextStyle(fontSize: 12.0, color: Colors.grey);

  @override
  void dispose() {
    super.dispose();
    _emailIdController.dispose();
    _passwordController.dispose();
    _nomeController.dispose();
    _cognomeController.dispose();
    _telefonoController.dispose();
    _indirizzoController.dispose();
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: _bottomBar(),
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
        constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/sfondo_login.jpg"), fit: BoxFit.cover),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(25.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.6),
                  hintText: 'Nome',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  isDense: true),
              style: _textStyleBlack,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: TextField(
              controller: _cognomeController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.6),
                  hintText: 'Cognome',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  isDense: true),
              style: _textStyleBlack,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: TextField(
              controller: _telefonoController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.6),
                  hintText: 'Telefono',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  isDense: true),
              style: _textStyleBlack,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: TextField(
              controller: _indirizzoController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.6),
                  hintText: 'Indirizzo',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  isDense: true),
              style: _textStyleBlack,
            ),
          ),
          GestureDetector(
            onTap: _singUpUser,
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
                      "Registrati",
                      style: TextStyle(color: Colors.white),
                    ),
              color: Colors.blue,
            ),
          )
        ]));
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
                      Text("Sei gia registrato? ", style: _textStyleGrey),
                      Container(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, signInScreenRoute);
                          },
                          child: Text('Torna al Login.', style: _textStyleGrey),
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

  void _singUpUser() async {
    if (_emailIdController.text.isEmpty) {
      showEmptyDialog("Compila il campo password,", context);
    } else if (_passwordController.text.length < 6) {
      showEmptyDialog("La password deve essere almeno 6 caratteri, e", context);
    } else if (_nomeController.text.isEmpty) {
      showEmptyDialog("Compila il campo nome,", context);
    } else if (_cognomeController.text.isEmpty) {
      showEmptyDialog("Compila il campo cognome,", context);
    } else if (_telefonoController.text.isEmpty) {
      showEmptyDialog("Compila il campo telefono,", context);
    } else if (_indirizzoController.text.isEmpty) {
      showEmptyDialog("Compila il campo indirizzo,", context);
    } else {
      setState(() {
        _isLoading = true;
      });
      String result = await SignUpMethods().signUpUser(
          email: _emailIdController.text,
          password: _passwordController.text,
          nome: _nomeController.text,
          cognome: _cognomeController.text,
          telefono: _telefonoController.text,
          indirizzo: _indirizzoController.text);
      if (result != 'success') {
        showSnackBar(result, context);
      } else {
        Navigator.pop(context);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }
}
