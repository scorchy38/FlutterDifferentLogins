import 'package:delivery/PhoneLogin.dart';
import 'package:delivery/WelcomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email, password;
  bool saveAttempt = false;
  final formKey = GlobalKey<FormState>();

  void _signIn(String email, String pw) {
    _auth
        .signInWithEmailAndPassword(email: email, password: pw)
        .then((authResult) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return new MaterialApp(
          theme: ThemeData(),
          home: PhoneLogin(),
        );
      }));
    }).catchError(
      (err) {
        print(err);
        if (err.code == 'ERROR_USER_NOT_FOUND') {
          showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text(
                      'This email is not yet registered. Create an account.'),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              });
        }
        if (err.code == 'ERROR_WRONG_PASSWORD') {
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text(
                    'Password is incorrect. Please enter correct password.'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        }
        if (err.code == 'ERROR_NETWORK_REQUEST_FAILED') {
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text(
                    'Your internet connection is either not available or too slow.'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color.fromRGBO(254, 61, 0, 0.77),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0), topLeft: Radius.circular(30.0)),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 64),
              child: Text(
                'Create an account',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 35.0),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              onChanged: (textValue) {
                setState(() {
                  email = textValue;
                });
              },
              autovalidate: saveAttempt,
              validator: (emailValue) {
                if (emailValue.isEmpty) {
                  return 'This field cannot be blank';
                }
                RegExp regExp = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                if (regExp.hasMatch(emailValue)) {
                  return null;
                }

                return 'Please enter a valid email';
              },
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                hintText: 'Enter Email',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: 24.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              onChanged: (textValue) {
                setState(() {
                  password = textValue;
                });
              },
              autovalidate: saveAttempt,
              validator: (pwValue) =>
                  pwValue.isEmpty ? 'This field cannot be blank' : null,
              obscureText: true,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                hintText: 'Password',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: 24.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  saveAttempt = true;
                });
                if (formKey.currentState.validate()) {
                  formKey.currentState.save();
                  _signIn(email, password);
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 34.0),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30.0)),
                child: Text(
                  'LOG IN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'FORGOT PASSWORD?',
              style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 34.0),
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: <Widget>[
                  Text(
                    'Swipe to Create Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Icon(
                    FontAwesomeIcons.arrowRight,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
