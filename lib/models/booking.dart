import 'package:json_annotation/json_annotation.dart';

part 'booking.g.dart';

@JsonSerializable()
class Booking {
  final int id;
  final String imgUrl;
  final String title;
  final String location;
  final String date;
  final String status;
  final String total;

  @JsonKey(name: 'time_start')
  final String timeStart;

  @JsonKey(name: 'time_end')
  final String timeEnd;

  @JsonKey(name: 'payment_status')
  final String payementStatus;

  @JsonKey(name: 'payment_method')
  final String paymentMethod;

  @JsonKey(name: 'payment_info')
  final String paymentInfo;

  Booking({
    this.id,
    this.imgUrl,
    this.title,
    this.location,
    this.date,
    this.status,
    this.total,
    this.timeStart,
    this.timeEnd,
    this.payementStatus,
    this.paymentMethod,
    this.paymentInfo,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return _$BookingFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$BookingToJson(this);
  }
}
