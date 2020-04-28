import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

class SocialLogin extends StatelessWidget {
  final LinearGradient backgroundGradient = LinearGradient(
      colors: [Hexcolor('#f7b733'), Hexcolor('#fc4a1a')],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: backgroundGradient,
          ),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new AppBar(
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      leading: new IconButton(
                        icon: new Icon(
                          Icons.arrow_back,
                          size: 25,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "Welcome to",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 2.0),
                        child: Text(
                          "sparring",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 8.0),
                        child: Text(
                          "Login for faster booking and to easily access your booking details",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width,
                        height: 40.0,
                        child: RaisedButton.icon(
                          icon: FaIcon(
                            FontAwesomeIcons.facebookF,
                            color: Colors.white,
                          ),
                          color: Hexcolor('#3b5998'),
                          onPressed: () {},
                          label: Text(
                            'Sign in with Facebook',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                      ),
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width,
                        height: 40.0,
                        child: RaisedButton.icon(
                          icon: FaIcon(
                            FontAwesomeIcons.google,
                            color: Colors.white,
                          ),
                          color: Hexcolor('#4c8bf5'),
                          onPressed: () {},
                          label: Text(
                            'Sign in with Google',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                      ),
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width,
                        height: 40.0,
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {},
                          child: Text(
                            'Sign in',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.white30,
                        thickness: 2.0,
                      ),
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width,
                        height: 40.0,
                        child: RaisedButton(
                          color: Colors.white,
                          onPressed: () {},
                          child: Text(
                            'Create account',
                            style: TextStyle(
                                color: Colors.black87, fontSize: 16.0),
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
      ),
    );
  }
}
