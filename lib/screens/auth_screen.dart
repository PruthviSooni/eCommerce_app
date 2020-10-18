import 'package:ecommerce_app/provider/auth.dart';
import 'package:ecommerce_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import '../models/http_exception.dart' as HttpExp;

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
  var _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  AuthState _authMode = AuthState.Login;
  var _isLoading = false;
  var _isVisible = true;
  var _key = GlobalKey<ScaffoldState>();

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
  Future<void> _formSaved() async {
    var provider = Provider.of<Auth>(context, listen: false);
    var _isValid = _formKey.currentState.validate();
    if (!_isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() => _isLoading = true);
    try {
      if (_authMode == AuthState.Login) {
        //login
        print('login');
        await provider.signIn(_emailController.text, _passwordController.text);
      } else {
        //signUp
        print("signUp");
        await provider.createAccount(
            _emailController.text, _passwordController.text);
      }
    } on HttpExp.HttpException catch (e) {
      var errorMeg = 'Authentication Failed!';
      if (e.toString().contains("EMAIL_EXISTS")) {
        errorMeg = 'Email is already exists.';
      } else if (e.toString().contains("INVALID_EMAIL")) {
        errorMeg = 'Email is invalid.';
      } else if (e.toString().contains("EMAIL_NOT_FOUND")) {
        errorMeg = 'Email Not Found.';
      } else if (e.toString().contains("INVALID_PASSWORD")) {
        errorMeg = 'Invalid Password.';
      } else if (e.toString().contains("WEAK_PASSWORD")) {
        errorMeg = 'Password is to weak.';
      }
      _key.currentState.showSnackBar(SnackBar(
        content: Text("$errorMeg"),
      ));
    }
    if (mounted) {
      setState(() => _isLoading = false);
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
    _controller_2.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final isPlatformDark =
        WidgetsBinding.instance.window.platformBrightness == Brightness.light;
    return Scaffold(
      key: _key,
      backgroundColor: isPlatformDark ? Colors.white : _animation_2.value,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 200),
        child: Form(
          key: _formKey,
          child: Align(
            alignment: Alignment.center,
            child: Column(
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
                        style: TextStyle(
                            fontSize: 32,
                            color: isPlatformDark
                                ? Colors.grey.shade900
                                : Colors.white),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  width: deviceSize.width,
                  duration: Duration(milliseconds: 500),
                  height: _authMode == AuthState.SignUp
                      ? deviceSize.height / 2.2
                      : 300,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade500,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12)),
                  margin: EdgeInsets.all(18),
                  padding:
                      EdgeInsets.only(bottom: 18, left: 18, right: 18, top: 18),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: kInputFieldDecoration.copyWith(
                              hintText: 'Email Address'),
                          focusNode: focusNode,
                          keyboardType: TextInputType.emailAddress,
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter email';
                            } else if (!value.contains('@') ||
                                !isEmail(value)) {
                              return 'Enter valid email';
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _isVisible,
                          decoration: kInputFieldDecoration.copyWith(
                            hintText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: showPassword,
                            ),
                          ),
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
                                obscureText: _isVisible,
                                controller: _confirmPasswordController,
                                decoration: kInputFieldDecoration.copyWith(
                                  hintText: 'Confirm Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(_isVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: showPassword,
                                  ),
                                ),
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please confirm password';
                                  } else if (value !=
                                      _passwordController.text) {
                                    return 'Entered password is different';
                                  }
                                },
                              )
                            : Container(),
                        SizedBox(height: 10),
                        AnimatedContainer(
                          width: _isLoading ? 70 : deviceSize.width,
                          decoration: BoxDecoration(),
                          duration: Duration(milliseconds: 500),
                          child: RaisedButton(
                            color: Theme
                                .of(context)
                                .accentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(_isLoading ? 100 : 12),
                            ),
                            onPressed: _formSaved,
                            child: _isLoading
                                ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 1.0, vertical: 5.0),
                              child: Container(
                                height: 35,
                                width: 35,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            )
                                : Text(
                                '${_authMode == AuthState.SignUp ? "SignUp" : "Login"}'),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: switchMode,
                          child: Text(
                            _authMode == AuthState.Login
                                ? 'SignUp here!'
                                : 'Login here.',
                            style: TextStyle(
                              color: isPlatformDark
                                  ? Colors.grey.shade900
                                  : Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void showPassword() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }
}
