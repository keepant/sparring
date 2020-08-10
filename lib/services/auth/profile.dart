import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sparring/components/loading.dart';
import 'package:sparring/pages/login/welcome_login.dart';
import 'package:sparring/pages/more/more.dart';

class ProfileCheck extends StatefulWidget {
  @override
  _ProfileCheckState createState() => _ProfileCheckState();
}

class _ProfileCheckState extends State<ProfileCheck> {
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
    return Scaffold(
      body: FutureBuilder<FirebaseUser>(
        future: checkCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Scaffold(
                body: Container(
                  //color: Color.fromARGB(255, 244, 194, 87),
                  child: Center(
                    child: Loading(),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.shade200,
                        offset: Offset(2, 4),
                        blurRadius: 5,
                        spreadRadius: 2,
                      )
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xfffbb448), Color(0xffe46b10)],
                    ),
                  ),
                ),
              );
            case ConnectionState.done:
              if (snapshot.data != null) return More();
              return WelcomeLoginPage();
          }
          return null;
        },
      ),
    );
  }
}
