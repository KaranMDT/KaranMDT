import 'dart:math';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Provider/auth.dart';
import 'package:shop_app/Screens/product_overview_screen.dart';

import '../model/http_exeption.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late Animation<Color?> _colorAnimation;
  late AnimationController _colorController;

  @override
  void initState() {
    super.initState();

    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(
        reverse: true,
      );
    _colorAnimation = ColorTween(
      end: const Color.fromARGB(255, 100, 213, 241).withOpacity(0.5),
      begin: const Color.fromARGB(255, 158, 95, 240).withOpacity(0.5),
    ).animate(_colorController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: <Widget>[
            AnimatedBuilder(
              animation: _colorAnimation,
              builder: (BuildContext context, Widget? child) {
                return Container(
                  color: _colorAnimation.value,
                );
              },
            ),
            SingleChildScrollView(
              child: Container(
                height: deviceSize.height,
                width: deviceSize.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20.0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 94.0),
                        transform: Matrix4.rotationZ(-12 * pi / 360)
                          ..translate(-5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 245, 90, 52)
                              .withOpacity(0.9),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 10,
                              color: Color.fromARGB(255, 65, 64, 64),
                              offset: Offset(1, 5),
                            )
                          ],
                        ),
                        child: Text(
                          'MyShop',
                          style: GoogleFonts.anton(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: deviceSize.width > 600 ? 2 : 1,
                      child: const AuthCard(),
                    ),
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

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  final _passwordController = TextEditingController();
  var _isLoading = false;

  bool emailvalid = true;
  bool passValid = true;
  bool confirmValid = true;

  AnimationController? _controller;
  Animation<double>? _heightAnimation;

  @override
  void initState() {
    emailvalid = false;
    passValid = false;
    confirmValid = false;
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 300),
    );

    _heightAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller!);

    _heightAnimation!.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    _heightAnimation!.removeListener(() {
      setState(() {});
    });
    super.dispose();
  }

  void _showsnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> _submit() async {
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(
          context,
          listen: false,
        ).login(
          _authData['email'].toString(),
          _authData['password'].toString(),
          context,
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'].toString(),
          _authData['password'].toString(),
          context,
        );
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ProductOverviewScreen(),
        ),
      );
    } on HttpException catch (error) {
      var errorMessage = "Authantication failed";
      if (error.toStrings().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toStrings().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toStrings().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toStrings().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toStrings().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid Password.';
      }
      _showsnackbar(errorMessage);
    } catch (error) {
      const errorMessage = "Could not authanticate you";
      _showsnackbar(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller!.reverse();
    }
  }

  bool validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);

    return regex.hasMatch(value.toString().trim());
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.Signup ? 320 : 260,
        ),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  decoration: const InputDecoration(
                    labelText: 'E-Mail',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (newvalue) {
                    if (!validateEmail(newvalue) && newvalue!.isNotEmpty) {
                      return "Enter valid email ID";
                    }
                  },
                  onChanged: (value) {
                    setState(
                      () => emailvalid = _formKey.currentState!.validate(),
                    );
                  },
                  onSaved: (value) {
                    _authData['email'] = value.toString();
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isNotEmpty && value.length <= 5) {
                      return "Password is too Short!";
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      passValid = _formKey.currentState!.validate();
                    });
                  },
                  onSaved: (value) {
                    _authData['password'] = value.toString();
                  },
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                    maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                  ),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _heightAnimation!,
                    child: TextFormField(
                      enabled: _authMode == AuthMode.Signup,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        errorText:
                            confirmValid ? "Password does not match" : null,
                      ),
                      obscureText: true,
                      onChanged: _authMode == AuthMode.Signup
                          ? (value) {
                              if (value != _passwordController.text &&
                                  value.isNotEmpty) {
                                setState(() {
                                  confirmValid = true;
                                });
                              } else {
                                setState(() {
                                  confirmValid = false;
                                });
                              }
                            }
                          : null,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  )
                else
                  ElevatedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: emailvalid == true && passValid == true
                        ? () {
                            _submit();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 8.0),
                      primary: Theme.of(context).primaryColor,
                    ),
                  ),
                TextButton(
                  child: Text(
                    '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                  ),
                  onPressed: _switchAuthMode,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 4),
                    primary: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
