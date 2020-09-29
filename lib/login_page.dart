import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task1/active_page.dart';
import 'package:task1/phone_login.dart';
import 'registration_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
bool showSpinner = false;

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: null,
        backgroundColor: Colors.white,
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String email;
    String password;
    return Container(
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(
                size: 170,
              ),
              Form(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Enter Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextField(
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Enter Password',
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.5, left: 250),
                        child: RaisedButton(
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              final newUser =
                                  await _auth.signInWithEmailAndPassword(
                                      email: email, password: password);
                              if (newUser != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ActivePage()));
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                          elevation: 1.0,
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                            textAlign: TextAlign.center,
                          ),
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ResgistraionScreen()));
                          },
                          child: Text(
                            'Sign up or Register !',
                            style: TextStyle(
                                fontSize: 15.0, color: Colors.blueAccent),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 20.0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              showSpinner = true;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhoneLogin(),
                              ),
                            );
                          },
                          child: Text(
                            'Mobile Phone Verification !',
                            style: TextStyle(
                                fontSize: 15.0, color: Colors.blueAccent),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 30),
                        child: ListTile(
                          leading: Icon(
                            Icons.thumb_up,
                            color: Colors.blueAccent,
                          ),
                          title: Text("Login with FaceBook"),
                          onTap: () {
                            setState(() {
                              showSpinner = true;
                            });
                            signUpWithFacebook().then((value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ActivePage())));
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: ListTile(
                          leading: Icon(
                            Icons.toys,
                            color: Colors.red,
                          ),
                          title: Text("Login with Google"),
                          onTap: () {
                            setState(() {
                              showSpinner = true;
                            });
                            _signIn().then(
                              (value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ActivePage(),
                                ),
                              ),
                            );
                            setState(() {
                              showSpinner = false;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: ListTile(
                          leading: Icon(
                            Icons.accessibility,
                            color: Colors.black87,
                          ),
                          title: Text("Sign In Anonymously"),
                          onTap: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            dynamic result = await signInAnon();
                            if (result == null) {
                              print('Error in signing in');
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ActivePage(),
                                ),
                              );
                              print('login succsec');
                              print(result.uid);
                            }
                            setState(() {
                              showSpinner = false;
                            });
                          },
                        ),
                      ),
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

Future signInAnon() async {
  try {
    AuthResult result = await _auth.signInAnonymously();
    FirebaseUser user = result.user;
    return user;
  } catch (e) {
    print(e.toString());
    return null;
  }
}

final GoogleSignIn googleSignIn = GoogleSignIn();
Future<FirebaseUser> _signIn() async {
  GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    idToken: googleSignInAuthentication.idToken,
    accessToken: googleSignInAuthentication.accessToken,
  );
  final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
  print("Username : ${user.displayName}");
  return user;
}

Future<void> signUpWithFacebook() async {
  try {
    final fb = FacebookLogin();
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

// Check result status
    switch (res.status) {
      case FacebookLoginStatus.Success:
        // Logged in

        // Send this access token to server for validation and auth
        // Send access token to server for validation and auth
        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: res.accessToken.token);
        final FirebaseUser user =
            (await FirebaseAuth.instance.signInWithCredential(credential)).user;
        print('Signed in' + user.displayName);
        return user;

        break;
      case FacebookLoginStatus.Cancel:
        // User cancel log in
        break;
      case FacebookLoginStatus.Error:
        // Log in failed
        print('Error while log in: ${res.error}');
        break;
    }
  } catch (e) {
    print(e);
  }
}
