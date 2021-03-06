import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/components/booking_card.dart';
import 'package:sparring/components/loading.dart';
import 'package:sparring/graphql/bookings.dart';
import 'package:sparring/i18n.dart';
import 'package:sparring/pages/bookings/booking_detail.dart';
import 'package:sparring/pages/utils/utils.dart';

class CompletedBooking extends StatefulWidget {
  CompletedBooking({Key key}) : super(key: key);

  @override
  _CompletedBookingState createState() => _CompletedBookingState();
}

class _CompletedBookingState extends State<CompletedBooking> {
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
          variables: {
            'id': _userId,
            'status': 'completed',
          },
        ),
        builder: (QueryResult result,
            {FetchMore fetchMore, VoidCallback refetch}) {
          if (result.loading) {
            return Loading();
          }

          if (result.hasException) {
            return Center(child: Text(result.exception.toString()));
          }

          if (result.data['bookings'].length == 0) {
            return EmptyListWidget(
              title: I18n.of(context).noBookingsText,
              subTitle: I18n.of(context).noCompletedBookingsText,
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
                icon: FontAwesomeIcons.solidCalendarCheck,
                status: booking['booking_status'].toUpperCase(),
                color: Colors.green,
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
