import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Me extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: RaisedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          child: Text("Logout"),
        ),
      ),
    );
  }
}