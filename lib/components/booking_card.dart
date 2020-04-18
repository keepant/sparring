import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BookingCard extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String location;
  final String date;
  final String time;
  final Widget icon;
  final Color color;
  final String status;

  BookingCard({
    this.imgUrl,
    this.title,
    this.location,
    this.date,
    this.time,
    this.icon,
    this.color,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: Card(
        elevation: 1,
        child: Padding(
          padding: EdgeInsets.all(1.0),
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
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imgUrl),
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
                        padding:
                            EdgeInsets.only(left: 8.0, top: 8.0, bottom: 2.0),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                height: 2.0,
                thickness: 1.0,
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: FaIcon(
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
                          child: FaIcon(
                            FontAwesomeIcons.clock,
                            size: 14.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(time),
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
                      child: icon,
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
