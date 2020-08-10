import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sparring/pages/utils/env.dart';

class SparringCard extends StatelessWidget {
  final String team1Name;
  final String team1Logo;
  final String team2Name;
  final String team2Logo;
  final String date;
  final String timeStart;
  final String timeEnd;
  final String court;
  final GestureTapCallback onTap;

  SparringCard({
    Key key,
    @required this.team1Name,
    @required this.team1Logo,
    @required this.team2Name,
    @required this.team2Logo,
    @required this.date,
    @required this.timeStart,
    @required this.timeEnd,
    @required this.court,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 210,
        child: Card(
          elevation: 1,
          child: Padding(
            padding: EdgeInsets.all(1.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                image: team1Logo == null || team1Logo == ''
                                    ? AssetImage("assets/img/default_logo.png")
                                    : FirebaseImage(
                                        fbTeamLogoURI + team1Logo,
                                      ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                          child: Text(
                            team1Name,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/icon/versus.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                image: team2Logo == null || team2Logo == ''
                                    ? AssetImage("assets/img/default_logo.png")
                                    : FirebaseImage(
                                        fbTeamLogoURI + team2Logo,
                                      ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                          child: Text(
                            team2Name,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Divider(
                  height: 2.0,
                  thickness: 1.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              FontAwesomeIcons.calendarAlt,
                              size: 14.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(date),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              FontAwesomeIcons.clock,
                              size: 14.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text("$timeStart - $timeEnd"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 2.0,
                  thickness: 1.0,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.0, left: 8.0, bottom: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.location_on,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          court,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
