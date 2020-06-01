import 'package:flutter/material.dart';
import 'package:sparring/pages/bookings/bookings.dart';
import 'package:sparring/pages/home.dart';
import 'package:sparring/pages/login/welcome_login.dart';

final routes = {
  '/': (BuildContext context) => Home(),
  '/login': (BuildContext context) => WelcomeLoginPage(),
  '/booking': (BuildContext context) => BookingsPage(),
};
