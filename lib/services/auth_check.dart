import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sparring/pages/bookings/bookings.dart';
import 'package:sparring/pages/login/welcome_login.dart';

class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;
  var token;

  @override
  void initState() {
    super.initState();
    checkCurrentUser();
  }

  Future<FirebaseUser> checkCurrentUser() async {
    try {
      user = await _firebaseAuth.currentUser();
      token = await user.getIdToken();
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: FutureBuilder<FirebaseUser>(
        future: checkCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Scaffold(
                body: Container(
                  color: Color.fromARGB(255, 244, 194, 87),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            case ConnectionState.done:
              if (snapshot.data != null)
                return BookingsPage(
                  token: token,
                  user: user,
                );
              return WelcomeLoginPage();
          }
          return null;
        },
      ),
    );
  }
}