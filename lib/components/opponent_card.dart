import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sparring/pages/utils/env.dart';
import 'package:sparring/pages/utils/utils.dart';

class OpponentCard extends StatelessWidget {
  final String teamName;
  final String date;
  final String timeStart;
  final String timeEnd;
  final String court;
  final String teamLogo;
  final GestureTapCallback onTap;

  OpponentCard({
    Key key,
    @required this.teamLogo,
    @required this.date,
    @required this.teamName,
    @required this.court,
    @required this.timeEnd,
    @required this.timeStart,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 130,
        child: Card(
          elevation: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                          image: FirebaseImage(
                            fbTeamLogoURI + teamLogo,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 8.0),
                        child: Text(
                          teamName,
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                  child: Text(formatDate(date)),
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
                                  child: Text(
                                      "${formatTime(timeStart)} - ${formatTime(timeEnd)}"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 2.0),
                              child: Icon(
                                Icons.location_on,
                                size: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              court,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
