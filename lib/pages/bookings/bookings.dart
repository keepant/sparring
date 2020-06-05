import 'package:flutter/material.dart';
import 'package:sparring/i18n.dart';
import 'package:sparring/pages/bookings/cancelled_booking.dart';
import 'package:sparring/pages/bookings/completed_booking.dart';
import 'package:sparring/pages/bookings/upcoming_booking.dart';
import 'package:sparring/pages/login/welcome_login.dart';
import 'package:sparring/services/prefs.dart';

class BookingsPage extends StatefulWidget {
  BookingsPage({
    Key key,
  }) : super(key: key);

  @override
  _BookingsPageState createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  Future<String> checkToken() async {
    return await prefs.getToken();
  }

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  @override
  Widget build(BuildContext context) {
    return checkToken() != null
        ? DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(I18n.of(context).myBookingTitle),
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
          )
        : WelcomeLoginPage();
  }
}
