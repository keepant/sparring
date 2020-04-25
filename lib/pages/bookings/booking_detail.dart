import 'package:flutter/material.dart';
import 'package:sparring/i18n.dart';

class BookingDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).bookingDetailsTitle),
      ),
      body: Text("data"),
    );
  }
}