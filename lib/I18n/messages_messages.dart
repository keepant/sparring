// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'messages';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "account" : MessageLookupByLibrary.simpleMessage("Account"),
    "booking" : MessageLookupByLibrary.simpleMessage("Bookings"),
    "bookingDetailsTitle" : MessageLookupByLibrary.simpleMessage("Booking Details"),
    "cancelledText" : MessageLookupByLibrary.simpleMessage("Cancelled"),
    "completedText" : MessageLookupByLibrary.simpleMessage("Completed"),
    "court" : MessageLookupByLibrary.simpleMessage("Court"),
    "doneText" : MessageLookupByLibrary.simpleMessage("Done"),
    "getStarted" : MessageLookupByLibrary.simpleMessage("Get Started"),
    "headerTextPage" : MessageLookupByLibrary.simpleMessage("Book futsal court\nand find opponents"),
    "hello" : MessageLookupByLibrary.simpleMessage("Hello, World"),
    "hintDateTextField" : MessageLookupByLibrary.simpleMessage("Play date"),
    "hintLocationCourtTextField" : MessageLookupByLibrary.simpleMessage("Location or name futsal court"),
    "hintTimeTextField" : MessageLookupByLibrary.simpleMessage("Play time"),
    "myBookingTitle" : MessageLookupByLibrary.simpleMessage("My Bookings"),
    "nextText" : MessageLookupByLibrary.simpleMessage("Next"),
    "notification" : MessageLookupByLibrary.simpleMessage("Notification"),
    "opponent" : MessageLookupByLibrary.simpleMessage("Opponents"),
    "searchText" : MessageLookupByLibrary.simpleMessage("Search"),
    "skipText" : MessageLookupByLibrary.simpleMessage("Skip"),
    "title" : MessageLookupByLibrary.simpleMessage("Sparring"),
    "upcomingText" : MessageLookupByLibrary.simpleMessage("Upcoming")
  };
}
