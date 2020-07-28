import 'package:empty_widget/empty_widget.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/components/booking_card.dart';
import 'package:sparring/components/loading.dart';
import 'package:sparring/graphql/bookings.dart';
import 'package:sparring/pages/bookings/booking_detail.dart';
import 'package:sparring/pages/utils/utils.dart';
import 'package:sparring/services/auth.dart';
import 'package:sparring/services/prefs.dart';

class UpcomingBooking extends StatefulWidget {
  UpcomingBooking({Key key}) : super(key: key);

  @override
  _UpcomingBookingState createState() => _UpcomingBookingState();
}

class _UpcomingBookingState extends State<UpcomingBooking> {
  SharedPreferences sharedPreferences;
  String _userId;

  _getUserId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _userId = (sharedPreferences.getString("userId") ?? '');
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserId();
  }
  
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: API.client,
      child: Query(
        options: QueryOptions(
            documentNode: gql(getAllBookings),
            pollInterval: 10,
            variables: {
              'id': _userId,
              'status': 'upcoming',
            }),
        builder: (QueryResult result,
            {FetchMore fetchMore, VoidCallback refetch}) {
          if (result.loading) {
            return Loading();
          }

          if (result.exception
              .toString()
              .contains("Could not verify JWT: JWTExpired: Undefined location")) {
            return FlatButton(
              child: Text("Logout"),
              onPressed: () async {
                final auth = new Auth();
                await auth.signOut();

                await prefs.clearToken();

                OneSignal.shared.removeExternalUserId();

                Navigator.of(context).popUntil(ModalRoute.withName("/"));

                Flushbar(
                  message: "Logout successfully!",
                  margin: EdgeInsets.all(8),
                  borderRadius: 8,
                  duration: Duration(seconds: 4),
                )..show(context);
              },
            );
          }

          if (result.hasException) {
            print(result.exception.toString());
            return Center(
              child: Text(result.exception.toString()),
            );
          }

          if (result.data['bookings'].length == 0) {
            return EmptyListWidget(
              title: 'No bookings',
              subTitle: 'No upcoming bookings available yet',
              image: null,
              packageImage: PackageImage.Image_4,
            );
          }

          return ListView.builder(
            itemCount: result.data['bookings'].length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var booking = result.data['bookings'][index];
              var court = result.data['bookings'][index]['court'];
              var img =
                  result.data['bookings'][index]['court']['court_images'][0];

              return BookingCard(
                imgUrl: img['name'],
                title: court['name'],
                location: court['address'],
                date: formatDate(booking['date']),
                timeStart: formatTime(booking['time_start']),
                timeEnd: formatTime(booking['time_end']),
                icon: FontAwesomeIcons.calendarAlt,
                status: booking['booking_status'].toUpperCase(),
                color: Colors.blue,
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: BookingDetail(
                      id: booking['id'],
                    ),
                    platformSpecific: false,
                    withNavBar: false,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
