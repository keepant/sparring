import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sparring/components/booking_card.dart';
import 'package:sparring/components/loading.dart';
import 'package:sparring/models/booking.dart';
import 'package:sparring/pages/bookings/booking_detail.dart';
import 'package:sparring/api/client.dart' as apiClient;

class UpcomingBooking extends StatelessWidget {
  final List<Booking> books;

  UpcomingBooking({Key key, this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Booking>>(
      future: apiClient.bookings('upcoming'),
      builder: (BuildContext context, AsyncSnapshot<List<Booking>> snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Center(
              child: Text(snapshot.error.toString()),
            ),
          );
        }

        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var booking = snapshot.data[index];

              return BookingCard(
                imgUrl: booking.imgUrl,
                title: booking.title,
                location: booking.location,
                date: booking.date,
                timeStart: booking.timeStart,
                timeEnd: booking.timeEnd,
                icon: FontAwesomeIcons.calendarDay,
                status: booking.status.toUpperCase(),
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
        }

        return Container(
          child: Loading(),
        );
      },
    );
  }
}
