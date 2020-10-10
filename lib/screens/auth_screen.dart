import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

enum AuthState { SignUp, Login }

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _showSignUp = false;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 700),
          height: _showSignUp ? 200 : 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(),
              TextFormField(),
              TextFormField(),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    _showSignUp = !_showSignUp;
                  });
                },
                child: Text('${_showSignUp ? "SignUp" : "Login"}'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
