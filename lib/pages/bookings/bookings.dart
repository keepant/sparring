import 'package:flutter/material.dart';
import 'package:sparring/i18n.dart';
import 'package:sparring/pages/bookings/cancelled_booking.dart';
import 'package:sparring/pages/bookings/completed_booking.dart';
import 'package:sparring/pages/bookings/upcoming_booking.dart';

class BookingsPage extends StatelessWidget {
  BookingsPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xffdee4eb),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            I18n.of(context).myBookingTitle,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 21.0,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Text(
                "Sparring",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[200],
                  fontSize: 16.0,
                ),
              ),
              onPressed: () {
                print("sparring");
              },
            )
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: I18n.of(context).upcomingText,
              ),
              Tab(
                text: I18n.of(context).completedText,
              ),
              Tab(
                text: I18n.of(context).cancelledText,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UpcomingBooking(),
            CompletedBooking(),
            CancelledBooking(),
          ],
        ),
      ),
    );
  }
}
