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

  String get backText {
    return Intl.message(
      'Back',
      name: 'backText',
      desc: 'back text button',
      locale: localeName,
    );
  }

  String get emailEmptyWarningText {
    return Intl.message(
      'Email can\'t be empty!',
      name: 'emailEmptyWarningText',
      desc: 'email empty warning text',
      locale: localeName,
    );
  }

  String get orText {
    return Intl.message(
      'or',
      name: 'orText',
      desc: 'or text',
      locale: localeName,
    );
  }

  String get loginWithFacebookText {
    return Intl.message(
      'Login with Facebook',
      name: 'loginWithFacebookText',
      desc: 'login with facebook text',
      locale: localeName,
    );
  }

  String get loginWithGoogleText {
    return Intl.message(
      'Login with Google',
      name: 'loginWithGoogleText',
      desc: 'login with google text',
      locale: localeName,
    );
  }

  String get questionAccountText {
    return Intl.message(
      'Don\'t have an account?',
      name: 'questionAccountText',
      desc: 'question account text',
      locale: localeName,
    );
  }

  String get emailText {
    return Intl.message(
      'Email',
      name: 'emailText',
      desc: 'email label text',
      locale: localeName,
    );
  }

  String get passwordText {
    return Intl.message(
      'Password',
      name: 'passwordText',
      desc: 'password text text',
      locale: localeName,
    );
  }

  String get questionHaveAccountText {
    return Intl.message(
      'Already have an account?',
      name: 'questionHaveAccountText',
      desc: 'question have account text',
      locale: localeName,
    );
  }

  String get fullNameText {
    return Intl.message(
      'Full name',
      name: 'fullNameText',
      desc: 'full name text label',
      locale: localeName,
    );
  }

  String get hourText {
    return Intl.message(
      'hour',
      name: 'hourText',
      desc: 'hour text',
      locale: localeName,
    );
  }

  String get paymentDetailsText {
    return Intl.message(
      'Payment details',
      name: 'paymentDetailsText',
      desc: 'payment details text',
      locale: localeName,
    );
  }

  String get paymentMethodText {
    return Intl.message(
      'Payment method',
      name: 'paymentMethodText',
      desc: 'payment method text',
      locale: localeName,
    );
  }

  String get youPayText {
    return Intl.message(
      'You pay',
      name: 'youPayText',
      desc: 'you pay text',
      locale: localeName,
    );
  }

  String get noBookingsText {
    return Intl.message(
      'No bookings',
      name: 'noBookingsText',
      desc: 'no booking text',
      locale: localeName,
    );
  }

  String get noCancelledBookingsText {
    return Intl.message(
      'No cancelled bookings available yet',
      name: 'noCancelledBookingsText',
      desc: 'no cancelled bookings text',
      locale: localeName,
    );
  }

  String get noCompletedBookingsText {
    return Intl.message(
      'No completed bookings available yet',
      name: 'noCompletedBookingsText',
      desc: 'no completed bookings text',
      locale: localeName,
    );
  }

  String get noUpcomingBookingsText {
    return Intl.message(
      'No upcoming bookings available yet',
      name: 'noUpcomingBookingsText',
      desc: 'no upcoming bookings text',
      locale: localeName,
    );
  }

  String get noSparringText {
    return Intl.message(
      'No sparring',
      name: 'noSparringText',
      desc: 'no sparring text',
      locale: localeName,
    );
  }

  String get noCancelledSparringText {
    return Intl.message(
      'No cancelled sparring available yet',
      name: 'noCancelledSparringText',
      desc: 'no cancelled sparring text',
      locale: localeName,
    );
  }

  String get noCompletedSparringText {
    return Intl.message(
      'No completed sparring available yet',
      name: 'noCompletedSparringText',
      desc: 'no completed Sparring text',
      locale: localeName,
    );
  }

  String get noUpcomingSparringText {
    return Intl.message(
      'No upcoming sparring available yet',
      name: 'noUpcomingSparringText',
      desc: 'no upcoming sparring text',
      locale: localeName,
    );
  }

  String get logoutSuccessText {
    return Intl.message(
      'Logout successfully!',
      name: 'logoutSuccessText',
      desc: 'logout success text',
      locale: localeName,
    );
  }

  String get logoutText {
    return Intl.message(
      'Logout',
      name: 'logoutText',
      desc: 'logout text',
      locale: localeName,
    );
  }

  String get noCourtText {
    return Intl.message(
      'No court',
      name: 'noCourtText',
      desc: 'no court text',
      locale: localeName,
    );
  }

  String get noCourtSearchText {
    return Intl.message(
      'No court match with the search',
      name: 'noCourtSearchText',
      desc: 'no court search text',
      locale: localeName,
    );
  }

  String get overviewText {
    return Intl.message(
      'Overview',
      name: 'overviewText',
      desc: 'overview text',
      locale: localeName,
    );
  }

  String get locationText {
    return Intl.message(
      'Location',
      name: 'locationText',
      desc: 'location text',
      locale: localeName,
    );
  }

  String get descriptionText {
    return Intl.message(
      'Description',
      name: 'descriptionText',
      desc: 'description text',
      locale: localeName,
    );
  }

  String get openDayText {
    return Intl.message(
      'Open day',
      name: 'openDayText',
      desc: 'open day text',
      locale: localeName,
    );
  }

  String get openHourText {
    return Intl.message(
      'Open hour',
      name: 'openHourText',
      desc: 'open hour text',
      locale: localeName,
    );
  }

  String get facilitiesText {
    return Intl.message(
      'Facilities',
      name: 'facilitiesText',
      desc: 'facilities text',
      locale: localeName,
    );
  }

  String get bookText {
    return Intl.message(
      'Book now',
      name: 'bookText',
      desc: 'book now text',
      locale: localeName,
    );
  }

  String get editSearchText {
    return Intl.message(
      'Edit search',
      name: 'editSearchText',
      desc: 'edit search text',
      locale: localeName,
    );
  }

  String get seeCourtDetailsText {
    return Intl.message(
      'see court details',
      name: 'seeCourtDetailsText',
      desc: 'see court details Text',
      locale: localeName,
    );
  }

  String get invoiceText {
    return Intl.message(
      'Invoice',
      name: 'invoiceText',
      desc: 'invoice text',
      locale: localeName,
    );
  }

  String get priceText {
    return Intl.message(
      'Price',
      name: 'priceText',
      desc: 'price text',
      locale: localeName,
    );
  }

  String get totalPriceText {
    return Intl.message(
      'Total price',
      name: 'totalPriceText',
      desc: 'total price text',
      locale: localeName,
    );
  }

  String get checkoutText {
    return Intl.message(
      'Checkout',
      name: 'checkoutText',
      desc: 'checkout text',
      locale: localeName,
    );
  }

  String get loginSuccessText {
    return Intl.message(
      'Login successfully!',
      name: 'loginSuccessText',
      desc: 'login success text',
      locale: localeName,
    );
  }

  String get passwordEmptyWarningText {
    return Intl.message(
      'Password can\'t be empty!',
      name: 'passwordEmptyWarningText',
      desc: 'password empty warning text',
      locale: localeName,
    );
  }

  String get fullNameEmptyWarningText {
    return Intl.message(
      'Full name can\'t be empty!',
      name: 'fullNameEmptyWarningText',
      desc: 'fullName empty warning text',
      locale: localeName,
    );
  }

  String get registerSuccessText {
    return Intl.message(
      'Register successfully!',
      name: 'registerSuccessText',
      desc: 'register success text',
      locale: localeName,
    );
  }

  String get descRegisterSuccessText {
    return Intl.message(
      'Please login to access your account',
      name: 'descRegisterSuccessText',
      desc: 'desc register success text',
      locale: localeName,
    );
  }

  String get saveProfileText {
    return Intl.message(
      'Profile picture saved!',
      name: 'saveProfileText',
      desc: 'save profile text',
      locale: localeName,
    );
  }

  String get saveText {
    return Intl.message(
      'Save',
      name: 'saveText',
      desc: 'save text',
      locale: localeName,
    );
  }

  String get savePPText {
    return Intl.message(
      'Saving profile picture..',
      name: 'savePPText',
      desc: 'save PP text',
      locale: localeName,
    );
  }

  String get profileText {
    return Intl.message(
      'Profile',
      name: 'profileText',
      desc: 'profile text',
      locale: localeName,
    );
  }

  String get phoneNumberText {
    return Intl.message(
      'Phone number',
      name: 'phoneNumberText',
      desc: 'phone number text',
      locale: localeName,
    );
  }

  String get phoneNumberEmptyWarningText {
    return Intl.message(
      'Phone number can\'t be empty!',
      name: 'phoneNumberEmptyWarningText',
      desc: 'phoneNumber empty warning text',
      locale: localeName,
    );
  }

  String get addressText {
    return Intl.message(
      'Address',
      name: 'addressText',
      desc: 'address text',
      locale: localeName,
    );
  }

  String get addressEmptyWarningText {
    return Intl.message(
      'Address can\'t be empty!',
      name: 'addressEmptyWarningText',
      desc: 'address empty warning text',
      locale: localeName,
    );
  }

  String get joinedText {
    return Intl.message(
      'Joined',
      name: 'joinedText',
      desc: 'joined text',
      locale: localeName,
    );
  }

  String get dataSavedText {
    return Intl.message(
      'Data saved!',
      name: 'dataSavedText',
      desc: 'data saved text',
      locale: localeName,
    );
  }

  String get savingChangesText {
    return Intl.message(
      'Saving changes..',
      name: 'savingChangesText',
      desc: 'saving changes text',
      locale: localeName,
    );
  }

  String get genderText {
    return Intl.message(
      'Gender',
      name: 'genderText',
      desc: 'gender text',
      locale: localeName,
    );
  }

  String get addTeamText {
    return Intl.message(
      'Add team',
      name: 'addTeamText',
      desc: 'add team text',
      locale: localeName,
    );
  }

  String get teamNameText {
    return Intl.message(
      'Team name',
      name: 'teamNameText',
      desc: 'team name text',
      locale: localeName,
    );
  }

  String get teamLocationText {
    return Intl.message(
      'Team base location',
      name: 'teamLocationText',
      desc: 'team location text',
      locale: localeName,
    );
  }

  String get teamLogoText {
    return Intl.message(
      'Team logo',
      name: 'teamLogoText',
      desc: 'team logo text',
      locale: localeName,
    );
  }

  String get noImageSelectedText {
    return Intl.message(
      'No image selected',
      name: 'noImageSelectedText',
      desc: 'no image selected text',
      locale: localeName,
    );
  }

  String get teamSavedText {
    return Intl.message(
      'Team saved!',
      name: 'teamSavedText',
      desc: 'team saved text',
      locale: localeName,
    );
  }

  String get savingTeamText {
    return Intl.message(
      'Saving team..',
      name: 'savingTeamText',
      desc: 'saving team text',
      locale: localeName,
    );
  }

  String get savingLogoText {
    return Intl.message(
      'Saving logo..',
      name: 'savingLogoText',
      desc: 'saving logo text',
      locale: localeName,
    );
  }

  String get logoSavedText {
    return Intl.message(
      'Logo saved!',
      name: 'logoSavedText',
      desc: 'logo saved text',
      locale: localeName,
    );
  }

  String get myTeamText {
    return Intl.message(
      'My Team',
      name: 'myTeamText',
      desc: 'my team text',
      locale: localeName,
    );
  }

  String get createdText {
    return Intl.message(
      'Created',
      name: 'createdText',
      desc: 'created text',
      locale: localeName,
    );
  }

  String get updateText {
    return Intl.message(
      'Update',
      name: 'updateText',
      desc: 'update text',
      locale: localeName,
    );
  }

  String get savingUpdateText {
    return Intl.message(
      'Saving update..',
      name: 'savingUpdateText',
      desc: 'saving update text',
      locale: localeName,
    );
  }

  String get aboutUsText {
    return Intl.message(
      'About Us',
      name: 'aboutUsText',
      desc: 'about us text',
      locale: localeName,
    );
  }

  String get descAppText {
    return Intl.message(
      'application for find futsal court and opponents',
      name: 'descAppText',
      desc: 'desc app text',
      locale: localeName,
    );
  }

  String get withText {
    return Intl.message(
      'with',
      name: 'withText',
      desc: 'with text',
      locale: localeName,
    );
  }

  String get appVersionText {
    return Intl.message(
      'App Version',
      name: 'appVersionText',
      desc: 'app version text',
      locale: localeName,
    );
  }

  String get myInfoText {
    return Intl.message(
      'My Information',
      name: 'myInfoText',
      desc: 'my info text',
      locale: localeName,
    );
  }

  String get loginOrRegisterText {
    return Intl.message(
      'Login / register',
      name: 'loginOrRegisterText',
      desc: 'login or register text',
      locale: localeName,
    );
  }

  String get opponentDetailText {
    return Intl.message(
      'Opponent detail',
      name: 'opponentDetailText',
      desc: 'opponent detail text',
      locale: localeName,
    );
  }

  String get makeSparringText {
    return Intl.message(
      'Success make sparring!',
      name: 'makeSparringText',
      desc: 'make sparring text',
      locale: localeName,
    );
  }

  String get pickOpponentText {
    return Intl.message(
      'Pick opponent',
      name: 'pickOpponentText',
      desc: 'pick opponent text',
      locale: localeName,
    );
  }

  String get pickOpponentConfirmText {
    return Intl.message(
      'Are you sure to pick this opponent?',
      name: 'pickOpponentConfirmText',
      desc: 'pick opponent confirm text',
      locale: localeName,
    );
  }

  String get cancelText {
    return Intl.message(
      'Cancel',
      name: 'cancelText',
      desc: 'cancel text',
      locale: localeName,
    );
  }

  String get sureText {
    return Intl.message(
      'Yes, sure',
      name: 'sureText',
      desc: 'sure text',
      locale: localeName,
    );
  }

  String get alertSelfSparringText {
    return Intl.message(
      'You cannot sparring with your own team 😋',
      name: 'alertSelfSparringText',
      desc: 'alert self sparring text',
      locale: localeName,
    );
  }

  String get makingSparringText {
    return Intl.message(
      'Making sparring..',
      name: 'makingSparringText',
      desc: 'making sparring text',
      locale: localeName,
    );
  }

  String get teamCaptainText {
    return Intl.message(
      'Team captain',
      name: 'teamCaptainText',
      desc: 'team captain text',
      locale: localeName,
    );
  }

  String get captainText {
    return Intl.message(
      'Captain',
      name: 'captainText',
      desc: 'captain text',
      locale: localeName,
    );
  }

  String get seeLocationText {
    return Intl.message(
      'See location',
      name: 'seeLocationText',
      desc: 'see location text',
      locale: localeName,
    );
  }

  String get currentSparringPostText {
    return Intl.message(
      'Your current sparring post',
      name: 'currentSparringPostText',
      desc: 'current sparring post text',
      locale: localeName,
    );
  }

  String get postSparringText {
    return Intl.message(
      'Post sparring',
      name: 'postSparringText',
      desc: 'postSparringtext',
      locale: localeName,
    );
  }

  String get noCourtAvailableText {
    return Intl.message(
      'No court available',
      name: 'noCourtAvailableText',
      desc: 'noCourtAvailableText',
      locale: localeName,
    );
  }

  String get makeBookingAlertText {
    return Intl.message(
      'Make booking court to post sparring!',
      name: 'makeBookingAlertText',
      desc: 'makeBookingAlertText',
      locale: localeName,
    );
  }

  String get sparringSuccessText {
    return Intl.message(
      'Sparring successfully saved',
      name: 'sparringSuccessText',
      desc: 'sparringSuccesText',
      locale: localeName,
    );
  }

  String get savingText {
    return Intl.message(
      'Saving..',
      name: 'savingText',
      desc: 'saving text',
      locale: localeName,
    );
  }

  String get confirmYesText {
    return Intl.message(
      'Yes, I pick this court',
      name: 'confirmYesText',
      desc: 'confirm yes text',
      locale: localeName,
    );
  }

  String get chooseThisCourtText {
    return Intl.message(
      'Choose this court?',
      name: 'chooseThisCourtText',
      desc: 'choose this court text',
      locale: localeName,
    );
  }

  String get dontHaveTeamText {
    return Intl.message(
      'You don\'t have any team yet!',
      name: 'dontHaveTeamText',
      desc: 'dontHaveTeam text',
      locale: localeName,
    );
  }

  String get addYourTeamText {
    return Intl.message(
      'Add your team to begin sparring',
      name: 'addYourTeamText',
      desc: 'addYourTeam text',
      locale: localeName,
    );
  }

  String get addTeamNowText {
    return Intl.message(
      'Add team now!',
      name: 'addTeamNowText',
      desc: 'addTeamNow text',
      locale: localeName,
    );
  }

  String get addSparringText {
    return Intl.message(
      'No sparring avalilable',
      name: 'addSparringText',
      desc: 'addSparring text',
      locale: localeName,
    );
  }

  String get oppInfoText {
    return Intl.message(
      'Opponents information',
      name: 'oppInfoText',
      desc: 'oppInfo text',
      locale: localeName,
    );
  }

  String get capInfoText {
    return Intl.message(
      'Caption information',
      name: 'capInfoText',
      desc: 'capInfo text',
      locale: localeName,
    );
  }

  String get nameText {
    return Intl.message(
      'Name',
      name: 'nameText',
      desc: 'name text',
      locale: localeName,
    );
  }

  String get oppDetailText {
    return Intl.message(
      'Sparring detail',
      name: 'oppDetailText',
      desc: 'oppDetail text',
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
