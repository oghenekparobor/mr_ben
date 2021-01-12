import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../helpers/http_exception.dart';

class ForgetPassword extends StatefulWidget {
  static const route = '/forget';
  ForgetPassword({Key key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  Map<String, String> _authData = {
    'email': '',
  };

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() => _isLoading = true);
    try {
      await Provider.of<Auth>(context, listen: false)
          .forgotPassword(_authData['email']);
    } on HttpException catch (error) {
      if (error.toString() != 'NO_USER_FOUND' ||
          error.toString() != 'MISSING_FIELDS' ||
          error.toString() != 'INVALID_REQUEST') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text('Password recovery mail has been sent!'),
            actions: [
              FlatButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  _formKey.currentState.reset();
                },
                child: Text('Ok'),
              )
            ],
          ),
        );
      }
    } catch (error) {
      home(error.toString());
      Navigator.of(context).pushReplacementNamed('/');
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
      ),
      backgroundColor: Color.fromRGBO(246, 246, 249, 1),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * .75,
                  width: double.infinity,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    child: LayoutBuilder(
                      builder: (ctx, constraint) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: constraint.maxHeight * .15),
                          Form(
                            key: _formKey,
                            child: Container(
                              child: Column(
                                children: [
                                  TextFormField(
                                    decoration: InputDecoration(
                                        labelText: 'Email address'),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (!value.contains('@') &&
                                          !value.contains('.')) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _authData['email'] = value;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: constraint.maxHeight * .1),
                          // Expanded(child: SizedBox()),
                          RaisedButton(
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: _submit,
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : Text(
                                    'Reset password',
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
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        child: Image.asset('assets/images/bella_logo.png'),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              alignment: Alignment.bottomCenter,
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 3,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Forgot password',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
