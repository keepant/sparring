import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparring/i18n.dart';
import 'package:sparring/pages/sparring/cancelled_sparring.dart';
import 'package:sparring/pages/sparring/completed_sparring.dart';
import 'package:sparring/pages/sparring/upcoming_sparring.dart';

class Sparring extends StatelessWidget {
  Sparring({
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).popUntil(ModalRoute.withName("/"));
            },
          ),
          title: Text(
            "Sparring",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 21.0,
            ),
          ),
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
            UpcomingSparring(),
            CompletedSparring(),
            CancelledSparring(),
          ],
        ),
      ),
    );
  }
}
