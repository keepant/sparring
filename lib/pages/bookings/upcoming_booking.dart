import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/components/booking_card.dart';
import 'package:sparring/components/loading.dart';
import 'package:sparring/graphql/bookings.dart';
import 'package:sparring/models/booking.dart';
import 'package:sparring/pages/bookings/booking_detail.dart';
import 'package:intl/intl.dart';

class UpcomingBooking extends StatelessWidget {
  final List<Booking> books;

  UpcomingBooking({Key key, this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: API.client,
      child: Query(
        options: QueryOptions(
            documentNode: gql(getBookings),
            pollInterval: 1,
            variables: {
              'status': 'upcoming',
            }),
        builder: (QueryResult result,
            {FetchMore fetchMore, VoidCallback refetch}) {
          return result.loading
              ? Loading()
              : result.hasException
                  ? Center(child: Text(result.exception.toString()))
                  : ListView.builder(
                      itemCount: result.data['bookings'].length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var booking = result.data['bookings'][index];
                        //var user = result.data['bookings'][index]['user'];
                        var court = result.data['bookings'][index]['court'];
                        var img = result.data['bookings'][index]['court']
                            ['court_images'][0];
                        return BookingCard(
                          imgUrl: img['name'],
                          title: court['name'],
                          location: court['address'],
                          date: new DateFormat.yMMMMd('en_US')
                              .format(DateTime.parse(booking['date']))
                              .toString(),
                          timeStart: new DateFormat.Hm()
                              .format(DateTime.parse(booking['date'] +
                                  ' ' +
                                  booking['time_start']))
                              .toString(),
                          timeEnd: new DateFormat.Hm()
                              .format(DateTime.parse(
                                  booking['date'] + ' ' + booking['time_end']))
                              .toString(),
                          icon: FontAwesomeIcons.calendarAlt,
                          status: booking['status'].toUpperCase(),
                          color: Colors.blue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingDetail(
                                  booking: booking,
                                ),
                              ),
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
