import 'package:flutter/material.dart';
import 'package:sparring/I18n/messages_all.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class I18n {
  I18n(this.localeName);

  static Future<I18n> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      return I18n(localeName);
    });
  }

  static I18n of(BuildContext context) {
    return Localizations.of<I18n>(context, I18n);
  }

  final String localeName;

  String get hello {
    return Intl.message(
      'Hello, World',
      name: 'hello',
      desc: 'Hello world text',
      locale: localeName,
    );
  }

  String get title {
    return Intl.message(
      'sparring',
      name: 'title',
      desc: 'Title application',
      locale: localeName,
    );
  }

  String get court {
    return Intl.message(
      'Court',
      name: 'court',
      desc: 'court text on bottom nav bar',
      locale: localeName,
    );
  }

  String get opponent {
    return Intl.message(
      'Opponents',
      name: 'opponent',
      desc: 'opponent text on bottom nav bar',
      locale: localeName,
    );
  }

  String get booking {
    return Intl.message(
      'Bookings',
      name: 'booking',
      desc: 'booking text on bottom nav bar',
      locale: localeName,
    );
  }

  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: 'notification text on bottom nav bar',
      locale: localeName,
    );
  }

  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: 'account text on bottom nav bar',
      locale: localeName,
    );
  }

  String get getStarted {
    return Intl.message(
      'Get Started',
      name: 'getStarted',
      desc: 'getStarted text button onboarding page',
      locale: localeName,
    );
  }

  String get skipText {
    return Intl.message(
      'Skip',
      name: 'skipText',
      desc: 'skip text button onboarding page',
      locale: localeName,
    );
  }

  String get nextText {
    return Intl.message(
      'Next',
      name: 'nextText',
      desc: 'next text button onboarding page',
      locale: localeName,
    );
  }

  String get doneText {
    return Intl.message(
      'Done',
      name: 'doneText',
      desc: 'done text button onboarding page',
      locale: localeName,
    );
  }

  String get bookingDetailsTitle {
    return Intl.message(
      'Booking Details',
      name: 'bookingDetailsTitle',
      desc: 'booking details text title app bar',
      locale: localeName,
    );
  }

  String get myBookingTitle {
    return Intl.message(
      'My Bookings',
      name: 'myBookingTitle',
      desc: 'my booking text on app bar',
      locale: localeName,
    );
  }

  String get upcomingText {
    return Intl.message(
      'Upcoming',
      name: 'upcomingText',
      desc: 'upcoming text on tab bar',
      locale: localeName,
    );
  }

  String get completedText {
    return Intl.message(
      'Completed',
      name: 'completedText',
      desc: 'competed text on tab bar',
      locale: localeName,
    );
  }

  String get cancelledText {
    return Intl.message(
      'Cancelled',
      name: 'cancelledText',
      desc: 'cancelled text on tab bar',
      locale: localeName,
    );
  }

  String get headerTextPage {
    return Intl.message(
      'Book futsal court\nand find opponents',
      name: 'headerTextPage',
      desc: 'header text on main page',
      locale: localeName,
    );
  }

  String get hintLocationCourtTextField {
    return Intl.message(
      'Location or name futsal court',
      name: 'hintLocationCourtTextField',
      desc: 'hint for text field location or name futsal court',
      locale: localeName,
    );
  }

  String get hintDateTextField {
    return Intl.message(
      'Play date',
      name: 'hintDateTextField',
      desc: 'hint for text field play date',
      locale: localeName,
    );
  }

  String get hintTimeTextField {
    return Intl.message(
      'Play time',
      name: 'hintTimeTextField',
      desc: 'hint for text field play time',
      locale: localeName,
    );
  }

  String get searchText {
    return Intl.message(
      'Search',
      name: 'searchText',
      desc: 'search text',
      locale: localeName,
    );
  }

  String get loginText {
    return Intl.message(
      'Login',
      name: 'loginText',
      desc: 'login text',
      locale: localeName,
    );
  }

  String get registerText {
    return Intl.message(
      'Register now',
      name: 'registerText',
      desc: 'register text',
      locale: localeName,
    );
  }

  String get loginDesc {
    return Intl.message(
      'Login for faster booking and to easily access your booking details',
      name: 'loginDesc',
      desc: 'login page description',
      locale: localeName,
    );
  }
}

class I18nDelegate extends LocalizationsDelegate<I18n> {
  const I18nDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'id'].contains(locale.languageCode);

  @override
  Future<I18n> load(Locale locale) => I18n.load(locale);

  @override
  bool shouldReload(I18nDelegate old) => false;
}
