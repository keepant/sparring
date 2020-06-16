import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/components/loading.dart';
import 'package:sparring/graphql/bookings.dart';
import 'package:sparring/i18n.dart';
import 'package:intl/intl.dart';

class BookingDetail extends StatelessWidget {
  final String id;

  BookingDetail({Key key, this.id}) : super(key: key);

  Color getColorStatus(String status) {
    if (status == 'completed') {
      return Colors.green;
    } else if (status == 'upcoming') {
      return Colors.blue;
    }

    return Colors.red;
  }

  Color getColorPayment(String status) {
    if (status == 'settlement') {
      return Colors.green;
    } else if (status == 'pending') {
      return Colors.blue;
    }

    return Colors.red;
  }

  IconData getIconStatus(String status) {
    if (status == 'completed') {
      return FontAwesomeIcons.solidCalendarCheck;
    } else if (status == 'upcoming') {
      return FontAwesomeIcons.calendarDay;
    }

    return FontAwesomeIcons.solidCalendarTimes;
  }

  IconData getIconPayment(String status) {
    if (status == 'settlement') {
      return FontAwesomeIcons.solidCheckCircle;
    } else if (status == 'pending') {
      return FontAwesomeIcons.solidQuestionCircle;
    }

    return FontAwesomeIcons.solidTimesCircle;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return GraphQLProvider(
      client: API.client,
      child: Query(
        options: QueryOptions(
          documentNode: gql(getBooking),
          pollInterval: 10,
          variables: {
            'id': id,
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

          return Scaffold(
            appBar: AppBar(
              title: Text(I18n.of(context).bookingDetailsTitle),
            ),
            body: ListView.builder(
              itemCount: result.data['bookings'].length,
              itemBuilder: (context, index) {
                var booking = result.data['bookings'][index];
                var court = result.data['bookings'][index]['court'];
                var img =
                    result.data['bookings'][index]['court']['court_images'][0];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setHeight(500),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(img['name']),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
                      child: Text(
                        court['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: Text(court['address']),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Icon(
                              getIconStatus(booking['status']),
                              color: getColorStatus(booking['status']),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              booking['booking_status'].toUpperCase(),
                              style: TextStyle(
                                color: getColorStatus(booking['status']),
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: FaIcon(
                                  FontAwesomeIcons.calendarAlt,
                                  size: 14.0,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(new DateFormat.yMMMMd('en_US')
                                    .format(DateTime.parse(booking['date']))
                                    .toString()),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: FaIcon(
                                  FontAwesomeIcons.clock,
                                  size: 14.0,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(new DateFormat.Hm()
                                        .format(DateTime.parse(booking['date'] +
                                            ' ' +
                                            booking['time_start']))
                                        .toString() +
                                    " - " +
                                    new DateFormat.Hm()
                                        .format(DateTime.parse(booking['date'] +
                                            ' ' +
                                            booking['time_end']))
                                        .toString()),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Container(height: 10.0, color: Colors.black12),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
                      child: Text(
                        'Payment Details',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Icon(
                              getIconPayment(booking['payment_status']),
                              color: getColorPayment(booking['payment_status']),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              booking['payment_status'].toUpperCase(),
                              style: TextStyle(
                                color:
                                    getColorPayment(booking['payment_status']),
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Payment Method",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            child: Text(
                              booking['payment_method'] == 'cod'
                                  ? 'Cash on Delivery (COD)'
                                  : booking['payment_method'].toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "You pay",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Rp " + booking['total_price'].toString(),
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
