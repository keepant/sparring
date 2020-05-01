import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sparring/i18n.dart';
import 'package:sparring/models/booking.dart';

class BookingDetail extends StatelessWidget {
  final Booking booking;

  BookingDetail({Key key, this.booking}) : super(key: key);

  Color getColorStatus(String status) {
    if(status == 'completed') {
      return Colors.green;
    } else if(status == 'upcoming') {
      return Colors.blue;
    }

    return Colors.red;
  } 

  Color getColorPayment(String status) {
    if(status == 'completed') {
      return Colors.green;
    } else if(status == 'pending') {
      return Colors.blue;
    }

    return Colors.red;
  } 

  IconData getIconStatus(String status) {
    if(status == 'completed') {
      return FontAwesomeIcons.solidCalendarCheck;
    } else if(status == 'upcoming') {
      return FontAwesomeIcons.calendarDay;
    }

    return FontAwesomeIcons.solidCalendarTimes;
  } 

  IconData getIconPayment(String status) {
    if(status == 'completed') {
      return FontAwesomeIcons.solidCheckCircle;
    } else if(status == 'pending') {
      return FontAwesomeIcons.solidQuestionCircle;
    }

    return FontAwesomeIcons.solidTimesCircle;
  } 

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).bookingDetailsTitle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: ScreenUtil().setHeight(500),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(booking.imgUrl),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
            child: Text(
              booking.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
            child: Text(
                booking.location),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Icon(
                    getIconStatus(booking.status),
                    color: getColorStatus(booking.status),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    booking.status.toUpperCase(),
                    style: TextStyle(
                      color: getColorStatus(booking.status), 
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
                      child: Text(booking.date),
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
                      child: Text(booking.timeStart+" - "+booking.timeEnd),
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Icon(
                    getIconPayment(booking.payementStatus),
                    color: getColorPayment(booking.payementStatus),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    booking.payementStatus.toUpperCase(),
                    style: TextStyle(
                      color: getColorPayment(booking.payementStatus),
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
                    "You pay",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  child: Text(
                    "Rp "+booking.total,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
            child: Text(
              'Payment Method',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(
                    booking.paymentMethod == 'cod' ? 'Cash on Delivery (COD)' : booking.paymentMethod,
                  ),
                ),
                Container(
                  child: Text(
                    booking.paymentInfo,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
