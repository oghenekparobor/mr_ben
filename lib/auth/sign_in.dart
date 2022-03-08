import 'package:Mr_Ben/auth/forget.dart';
import 'package:Mr_Ben/auth/wait.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../helpers/http_exception.dart';
import '../providers/auth.dart';

class SignIn extends StatefulWidget {
  static const route = '/sign-in';
  const SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() => _isLoading = true);
    try {
      await Provider.of<Auth>(context, listen: false).signIn(
        _authData['email'],
        _authData['password'],
      );
      Navigator.of(context).pushReplacementNamed(WaitScreen.route);
      showToast('Welcome');
    } on HttpException catch (error) {
      if (error.toString() == 'INVALID_CREDENTIALS') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text('Invalid login credential, please try again'),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    _formKey.currentState.reset();
                  },
                  child: Text('Ok'))
            ],
          ),
        );
      }
    } catch (error) {
      Navigator.of(context).pushReplacementNamed(WaitScreen.route);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void home(String message) {
    Navigator.of(context).pop(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 50),
        child: LayoutBuilder(
          builder: (ctx, constraint) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: constraint.maxHeight * .23),
              Form(
                key: _formKey,
                child: Container(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Email address'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (!value.contains('@') && !value.contains('.')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['email'] = value;
                        },
                      ),
                      SizedBox(height: constraint.maxHeight * .05),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value.length < 6) {
                            return 'Password length must six characters above';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['password'] = value;
                        },
                        onFieldSubmitted: (w) {
                          _submit();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: constraint.maxHeight * .05),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(ForgetPassword.route),
                  child: Text(
                    'Forgot password ?',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
              MaterialButton(
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  vertical: constraint.maxHeight * 0.03,
                ),
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: _submit,
                child: _isLoading
                    ? CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        strokeWidth: 1,
                      )
                    : Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
              ),
              SizedBox(height: constraint.maxHeight * .05),
            ],
          ),
        ),
      ),
    );
  }
}

showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.CENTER,
    textColor: Colors.white,
    backgroundColor: Color.fromRGBO(0, 0, 0, 1),
    toastLength: Toast.LENGTH_LONG,
  );
}
