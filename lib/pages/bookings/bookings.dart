import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sparring/i18n.dart';
import 'package:sparring/pages/bookings/cancelled_booking.dart';
import 'package:sparring/pages/bookings/completed_booking.dart';
import 'package:sparring/pages/bookings/upcoming_booking.dart';
import 'package:sparring/pages/login/welcome_login.dart';
import 'package:sparring/services/prefs.dart';

class BookingsPage extends StatelessWidget {
  final FirebaseUser user;
  final token;

  BookingsPage({
    Key key,
    this.user,
    this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return prefs.getToken() == null ? WelcomeLoginPage() : DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(I18n.of(context).myBookingTitle),
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

  Prefs() {}
}
