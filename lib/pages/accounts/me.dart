import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparring/services/auth.dart';
import 'package:sparring/services/prefs.dart';

class Me extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: RaisedButton(
          onPressed: () async {
            final auth = new Auth();
            await auth.signOut();

            await prefs.clearToken();
                      
            Flushbar(
              message: "Logout successfully!",
              margin: EdgeInsets.all(8),
              borderRadius: 8,
              duration: Duration(seconds: 4),
            )..show(context);
          },
          child: Text("Logout"),
        ),
      ),
    );
  }
}