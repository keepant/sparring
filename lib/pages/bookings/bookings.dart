import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sparring/pages/bookings/cancelled_booking.dart';
import 'package:sparring/pages/bookings/completed_booking.dart';
import 'package:sparring/pages/bookings/upcoming_booking.dart';

class BookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Bookings"),
          actions: <Widget>[
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.running,
                color: Colors.white,
              ),
              onPressed: () {},
            )
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Upcoming",
              ),
              Tab(
                text: "Completed",
              ),
              Tab(
                text: "Cancelled",
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
