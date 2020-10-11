import 'package:ecommerce_app/utils/constants.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = 'AuthScreen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

enum AuthState { SignUp, Login }

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  AnimationController _controller, _controller_2;
  Animation<double> _animation;
  Animation<Color> _animation_2;
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  AuthState _authMode = AuthState.Login;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(curve: Curves.easeIn, parent: _controller);
    _controller_2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation_2 = (ColorTween(
      begin: Colors.grey.shade500,
      end: Colors.grey.shade900,
    ).animate(_controller_2)
      ..addListener(
        () => setState(() {}),
      ));
    _controller.forward();
    _controller_2.forward();
    super.initState();
  }

  var focusNode = FocusNode();

  _formSaved() {
    var _isValid = _formKey.currentState.validate();
    if (!_isValid) {
      return;
    }
    _formKey.currentState.save();
    if (_authMode == AuthState.Login) {
      //login
      print('login');
    } else {
      //signUp
      print("signUp");
      if (_emailController.text.isNotEmpty ||
          _passwordController.text.isNotEmpty) {}
    }
  }

  void switchMode() {
    if (_authMode == AuthState.Login) {
      setState(() {
        _authMode = AuthState.SignUp;
      });
    } else {
      setState(() {
        _authMode = AuthState.Login;
      });
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: _animation_2.value,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              width: deviceSize.width,
              duration: Duration(milliseconds: 500),
              height: _authMode == AuthState.SignUp ? 450 : 400,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade500,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12)),
              margin: EdgeInsets.all(18),
              padding: EdgeInsets.all(18),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _animation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            child: Image.asset('images/appIcon.png'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "ECommerce Store",
                            style: TextStyle(fontSize: 32),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    TextFormField(
                      controller: _emailController,
                      decoration: kInputFieldDecoration.copyWith(
                          hintText: 'Email Address'),
                      focusNode: focusNode,
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter email';
                        } else if (!value.contains('@')) {
                          return 'Enter valid email';
                        }
                      },
                      onChanged: (value) {
                        value = _email;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      decoration:
                          kInputFieldDecoration.copyWith(hintText: 'Password'),
                      onChanged: (value) {
                        value = _password;
                      },
                      // ignore: missing_return
                      validator: (value) {
                        if (value.length < 6) {
                          return 'Password length should be 6 at least';
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    _authMode == AuthState.SignUp
                        ? TextFormField(
                            decoration: kInputFieldDecoration.copyWith(
                                hintText: 'Confirm Password'),
                            // ignore: missing_return
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please confirm password';
                              } else if (value != _passwordController.text) {
                                return 'Entered password is different';
                              }
                            },
                          )
                        : Container(),
                    SizedBox(height: 8),
                    Container(
                      width: deviceSize.width,
                      decoration: BoxDecoration(),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onPressed: _formSaved,
                        child: Text(
                            '${_authMode == AuthState.SignUp ? "SignUp" : "Login"}'),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: switchMode,
                      child: Text(_authMode == AuthState.Login
                          ? 'SignUp here!'
                          : 'Login here'),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
