import 'package:Mr_Ben/auth/wait.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../helpers/http_exception.dart';

class SignUp extends StatefulWidget {
  static const route = '/sign-up';
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  final _passwordController = TextEditingController();
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
      await Provider.of<Auth>(context, listen: false)
          .signUp(_authData['email'], _authData['password']);
      Navigator.of(context).pushReplacementNamed(WaitScreen.route);
    } on HttpException catch (error) {
      if (error.toString() == 'CREDENTIAL_EXISTS') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(
              'Credential already exist, please try again with another email',
            ),
            actions: [
              FlatButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    _formKey.currentState.reset();
                  },
                  child: Text('Ok'))
            ],
          ),
        );
      } else if (error.toString() == 'REGISTRATION_SUCCESS') {
        Provider.of<Auth>(context, listen: false)
            .signIn(_authData['email'], _authData['password'])
            .then(
              (value) =>
                  Navigator.of(context).pushReplacementNamed(WaitScreen.route),
            );
      }
    } catch (error) {
      Navigator.of(context).pushReplacementNamed(WaitScreen.route);
    }
    setState(() => _isLoading = false);
  }

  // else if (error.toString() == 'REGISTRATION_SUCCESS') {
  //       showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           content: Text('Registration successful! Please login.'),
  //           actions: [
  //             FlatButton(
  //                 onPressed: () async {
  //                   Navigator.of(context)
  //                       .pushReplacementNamed(GetStarted.route);
  //                   _formKey.currentState.reset();
  //                 },
  //                 child: Text('Ok'))
  //           ],
  //         ),
  //       );
  //     }

  @override
  dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
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
                      SizedBox(height: constraint.maxHeight * .05),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Confirm password'),
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
              Expanded(child: SizedBox()),
              RaisedButton(
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  vertical: constraint.maxHeight * 0.03,
                ),
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: _submit,
                child: _isLoading
                    ? CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        strokeWidth: 1,
                      )
                    : Text(
                        'Sign-up',
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
