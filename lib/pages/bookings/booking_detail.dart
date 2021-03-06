import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/components/loading.dart';
import 'package:sparring/graphql/bookings.dart';
import 'package:sparring/i18n.dart';
import 'package:intl/intl.dart';
import 'package:sparring/models/booking_payment_status.dart';
import 'package:sparring/api/client.dart' as midtransClient;
import 'package:sparring/pages/utils/env.dart';
import 'package:sparring/pages/utils/utils.dart';

class BookingDetail extends StatelessWidget {
  final int id;

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
              shrinkWrap: true,
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
                          image: FirebaseImage(
                            fbCourtURI + img['name'],
                          ),
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
                              getIconStatus(booking['booking_status']),
                              color: getColorStatus(booking['booking_status']),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              booking['booking_status'].toUpperCase(),
                              style: TextStyle(
                                color:
                                    getColorStatus(booking['booking_status']),
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
                                child: Text(
                                    "${formatTime(booking['time_start'])} - ${formatTime(booking['time_end'])}"),
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
                        I18n.of(context).paymentDetailsText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    FutureBuilder<BookingPaymentStatus>(
                      future: midtransClient
                          .bookingPaymentStatus(booking['order_id']),
                      builder: (BuildContext context,
                          AsyncSnapshot<BookingPaymentStatus> snapshot) {
                        if (snapshot.hasError) {
                          return Expanded(
                            child: Center(
                              child: Text(snapshot.error.toString()),
                            ),
                          );
                        }

                        if (snapshot.hasData) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 4.0, 16.0, 4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Icon(
                                        getIconPayment(
                                            snapshot.data.transactionStatus),
                                        color: getColorPayment(
                                            snapshot.data.transactionStatus),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        snapshot.data.transactionStatus
                                            .toUpperCase(),
                                        style: TextStyle(
                                          color: getColorPayment(
                                              snapshot.data.transactionStatus),
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
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 4.0, 16.0, 4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        I18n.of(context).paymentMethodText,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        snapshot.data.paymentType.toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 4.0, 16.0, 4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        I18n.of(context).youPayText,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        formatCurrency(booking['total_price']),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 25,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 20,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 20,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
