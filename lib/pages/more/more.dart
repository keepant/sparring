import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparring/components/text_style.dart';
import 'package:sparring/pages/more/about.dart';
import 'package:sparring/services/auth.dart';
import 'package:sparring/services/prefs.dart';

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 21.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                      radius: 50, child: Image.asset('assets/img/pp.png')),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        BoldText(
                          text: "Irfan Dwi Prasetyo",
                          size: 20.0,
                          color: Colors.black,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Colors.grey,
                              size: 15.0,
                            ),
                            NormalText(
                                text: "Oran,Algeria",
                                color: Colors.grey,
                                size: 16.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Divider(
              thickness: 2,
            ),
            SizedBox(
              height: 5.0,
            ),
            _profileItem(
              icon: FontAwesomeIcons.userAlt,
              text: "My Informations",
            ),
            _profileItem(
              icon: FontAwesomeIcons.userFriends,
              text: "My Team",
            ),
            _profileItem(
                icon: FontAwesomeIcons.infoCircle,
                text: "About Us ",
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: AboutUs(),
                    platformSpecific: false,
                    withNavBar: false,
                  );
                }),
            _profileItem(
              icon: FontAwesomeIcons.signOutAlt,
              text: "Logout",
              onTap: () async {
                final auth = new Auth();
                await auth.signOut();

                await prefs.clearToken();

                OneSignal.shared.removeExternalUserId();

                Flushbar(
                  message: "Logout successfully!",
                  margin: EdgeInsets.all(8),
                  borderRadius: 8,
                  duration: Duration(seconds: 4),
                )..show(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileItem({IconData icon, String text, GestureTapCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 6, top: 6),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: Colors.black54,
              size: 30,
            ),
            SizedBox(
              width: 15,
            ),
            NormalText(
              text: text,
              color: Colors.black,
              size: 20.0,
            )
          ],
        ),
      ),
    );
  }
}
