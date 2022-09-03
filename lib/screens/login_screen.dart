import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum AuthMode { login, signup }

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  AuthMode _authMode = AuthMode.login;

  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String?> _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;

  Widget _textFormField(
    String fieldTitle,
    TextEditingController textController,
    IconData icon,
    TextInputType inputType,
    String? Function(String?)? validateFunc,
    void Function(String?)? onSaveFunc,
  ) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        keyboardType: inputType,
        style: Theme.of(context).textTheme.bodyText1,
        controller: textController,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Theme.of(context).backgroundColor,
          hintText: fieldTitle,
          hintStyle: Theme.of(context).textTheme.bodyText2,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide.none,
          ),
        ),
        textAlign: TextAlign.left,
        onSaved: onSaveFunc,
        validator: validateFunc,
      ),
    );
  }

  Widget _confirmFormField(
    String fieldTitle,
    TextEditingController textController,
    IconData icon,
    TextInputType inputType,
    String? Function(String?)? validateFunc,
  ) {
    return AnimatedContainer(
      constraints: BoxConstraints(
        minHeight: _authMode == AuthMode.signup ? 100 : 0,
        maxHeight: _authMode == AuthMode.signup ? 100 : 0,
      ),
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 300),
      child: SizedBox(
        width: 300,
        child: TextFormField(
          enabled: _authMode == AuthMode.signup,
          keyboardType: inputType,
          style: Theme.of(context).textTheme.bodyText1,
          controller: textController,
          decoration: InputDecoration(
            prefixIcon: _authMode == AuthMode.login ? null : Icon(icon),
            filled: true,
            fillColor: Theme.of(context).backgroundColor,
            hintText: _authMode == AuthMode.login ? '' : fieldTitle,
            hintStyle: Theme.of(context).textTheme.bodyText2,
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide.none,
            ),
          ),
          textAlign: TextAlign.left,
          validator: _authData == AuthMode.signup ? validateFunc : null,
        ),
      ),
    );
  }

  Widget _flatButton(String text) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
      ),
      onPressed: _switchAuthMode,
      child: Text(
        '${_authMode == AuthMode.login ? 'สมัครสมาชิก' : 'เข้าสู่ระบบ'}',
        style: Theme.of(context).textTheme.subtitle1?.copyWith(
              decoration: TextDecoration.underline,
            ),
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: 300,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
        ),
        onPressed: _submit,
        child: Text(
          'ล็อกอิน',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      print('Invalid');
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed.';
      if (error.toString().contains('EMAIL_EXIST')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email address.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid passwrod.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not authenticate you, try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error occurred'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Okay'),
          )
        ],
      ),
    );
  }

  Widget _sizedBox(double height) {
    return SizedBox(
      height: height,
    );
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
      print('authmode = $_authMode');
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      print('authmode = $_authMode');
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            width: deviceSize.width,
            height: deviceSize.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login-bg.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
              ),
            ),
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'เข้าสู่ระบบ',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      _sizedBox(20),
                      _textFormField(
                        'Email',
                        _emailController,
                        Icons.email_rounded,
                        TextInputType.emailAddress,
                        (emailInput) {
                          if (emailInput!.isEmpty ||
                              !emailInput.contains('@')) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                        (value) {
                          _authData['email'] = value;
                        },
                      ),
                      _sizedBox(20),
                      _textFormField(
                        'Password',
                        _pwController,
                        Icons.lock_rounded,
                        TextInputType.text,
                        (pwInput) {
                          if (pwInput!.isEmpty || pwInput.length < 5) {
                            return 'Password is too short!';
                          }
                          return null;
                        },
                        (pwInput) {
                          _authData['password'] = pwInput;
                        },
                      ),
                      _sizedBox(20),
                      _confirmFormField(
                        'Confirm Password',
                        _confirmPwController,
                        Icons.lock_rounded,
                        TextInputType.text,
                        (pwConfirmInput) {
                          if (pwConfirmInput != _pwController.text) {
                            return 'Passwords do not match!';
                          }
                          return null;
                        },
                      ),
                      _sizedBox(20),
                      _submitButton(),
                      _sizedBox(10),
                      _flatButton('สมัครสมาชิก'),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
