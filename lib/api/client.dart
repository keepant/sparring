import 'package:dio/dio.dart';
import 'package:sparring/api/http.dart' as httpClient;
import 'package:sparring/models/booking.dart';

class FetchException implements Exception {
  final DioError _error;
  final String _message;

  FetchException([this._error, this._message]);

  String toString() {
    return "Exception: $_message.\n${_error.message}";
  }
}

Future<List<Booking>> bookings(String status) async {
  try {
    Response response = await httpClient.bookings();
    List<Booking> bookings = [];

    for (var i = 0; i < response.data.length; i++) {
      if (response.data[i]['status'] == status) {
        bookings.add(Booking.fromJson(response.data[i]));
      }
    }

    return bookings;
  } on DioError catch (err) {
    throw FetchException(err, 'unable to load bookings');
  }
}
