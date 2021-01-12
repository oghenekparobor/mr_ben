import 'dart:convert';

import 'package:Mr_Ben/providers/auth.dart';
import 'package:Mr_Ben/screens/address.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class ProfileEdit extends StatefulWidget {
  static const route = '/profile_edit';
  const ProfileEdit({Key key}) : super(key: key);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController addressController = new TextEditingController();
  Map<String, dynamic> details;
  Map<String, dynamic> _details = {
    'mobile': '',
    'address': '',
    'name': '',
  };
  var _isLoading = false;

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() => _isLoading = true);
    try {
      await Provider.of<Auth>(context, listen: false).updateUserDetails(
          _details['name'], _details['mobile'], _details['address']);
    } catch (error) {
      print(error);
    }
    setState(() => _isLoading = false);
    Navigator.of(context).pop();
  }

  void launchMail() async {
    const url = 'mailto:bellaonloje@gmail.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Cannot launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    if (auth != null) details = json.decode(auth.userDetail);
    addressController.text = details['address'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
      ),
      backgroundColor: Color.fromRGBO(246, 246, 249, 1),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: LayoutBuilder(
          builder: (ctx, constraint) => ListView(
            children: [
              SizedBox(height: constraint.maxHeight * .02),
              Text(
                'Edit profile',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: constraint.maxHeight * .02),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      width: 50,
                      height: 50,
                      child: Image.asset('assets/images/logo.png'),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              initialValue: details['username'],
                              autofocus: true,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Customer name cannot be empty';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _details['name'] = value;
                              },
                              decoration: InputDecoration(
                                hintText: 'Full name',
                                hintStyle: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            TextFormField(
                              initialValue: details['mobile'],
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Mobile number cannot be empty';
                                }
                                if (value.length < 11) {
                                  return 'Mobile number is not complete';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _details['mobile'] = value;
                              },
                              decoration: InputDecoration(
                                // border: InputBorder.none,
                                hintText: 'Mobile number',
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            // SizedBox(height: 5),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(Address.route)
                                    .then(
                                  (value) {
                                    if (value != null)
                                      addressController.text = value;
                                  },
                                );
                              },
                              child: TextFormField(
                                controller: addressController,
                                enabled: false,
                                // initialValue: ,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                                keyboardType: TextInputType.multiline,
                                minLines: 2,
                                maxLines: null,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Address is empty';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _details['address'] = value;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Address',
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: constraint.maxHeight * .4),
              RaisedButton(
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  vertical: constraint.maxHeight * 0.025,
                ),
                color: Theme.of(context).primaryColor,
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
                        'Update',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
              ),
              SizedBox(height: constraint.maxHeight * .02),
            ],
          ),
        ),
      ),
    );
  }
}
