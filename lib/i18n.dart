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
      'Sparring',
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
