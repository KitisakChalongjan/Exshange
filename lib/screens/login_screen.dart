import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  var db;

  bool _obscurePassword = true;

  AuthMode _authMode = AuthMode.login;

  String? errorMessage = '';

  final GlobalKey<FormState> _formKey = GlobalKey();

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;

  Widget _textFormField(
    String fieldTitle,
    TextEditingController textController,
    bool isObscured,
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
        obscureText: fieldTitle == 'Password' ? _obscurePassword : false,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Theme.of(context).backgroundColor,
          hintText: fieldTitle,
          hintStyle: Theme.of(context).textTheme.caption,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide.none,
          ),
          suffixIcon: fieldTitle == 'Password'
              ? IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                )
              : null,
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
            hintStyle: Theme.of(context).textTheme.caption,
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
        '${_authMode == AuthMode.login ? '?????????????????????????????????' : '?????????????????????????????????'}',
        style: Theme.of(context).textTheme.subtitle1?.copyWith(
              decoration: TextDecoration.underline,
            ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
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
        onPressed: () => _submit(context),
        child: Text(
          _authMode == AuthMode.login ? '?????????????????????' : '?????????????????????????????????',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      print('Invalid');
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    //await FirestoreHelper().db.collection('users').add();
    try {
      if (_authMode == AuthMode.login) {
        await context.read<Authentication>().signInWithEmailAndPassword(
              email: _authData['email']!.trim(),
              password: _authData['password']!.trim(),
            );
      } else {
        await context.read<Authentication>().createUserWithEmailAndPassword(
              email: _authData['email']!.trim(),
              password: _authData['password']!.trim(),
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
    } catch (error) {
      const errorMessage = 'Could not authenticate you, try again later.';
      _showErrorDialog(error.toString());
    }
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
              setState(() {
                _isLoading = false;
              });
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
        _confirmPwController.text = '';
      });
      print('authmode = $_authMode');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build login');
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
                        '?????????????????????????????????',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      _sizedBox(20),
                      _textFormField(
                        'Email',
                        _emailController,
                        _obscurePassword,
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
                          _authData['email'] = value!;
                        },
                      ),
                      _sizedBox(20),
                      _textFormField(
                        'Password',
                        _pwController,
                        _obscurePassword,
                        Icons.lock_rounded,
                        TextInputType.text,
                        (pwInput) {
                          if (pwInput!.isEmpty || pwInput.length < 5) {
                            return 'Password is too short!';
                          }
                          return null;
                        },
                        (pwInput) {
                          _authData['password'] = pwInput!;
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
                      _submitButton(context),
                      _sizedBox(10),
                      _flatButton('?????????????????????????????????'),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
