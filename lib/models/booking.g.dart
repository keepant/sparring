// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Booking _$BookingFromJson(Map<String, dynamic> json) {
  return Booking(
    id: json['id'] as int,
    imgUrl: json['imgUrl'] as String,
    title: json['title'] as String,
    location: json['location'] as String,
    date: json['date'] as String,
    status: json['status'] as String,
    total: json['total'] as String,
    timeStart: json['time_start'] as String,
    timeEnd: json['time_end'] as String,
    payementStatus: json['payment_status'] as String,
    paymentMethod: json['payment_method'] as String,
    paymentInfo: json['payment_info'] as String,
  );
}

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
      'id': instance.id,
      'imgUrl': instance.imgUrl,
      'title': instance.title,
      'location': instance.location,
      'date': instance.date,
      'status': instance.status,
      'total': instance.total,
      'time_start': instance.timeStart,
      'time_end': instance.timeEnd,
      'payment_status': instance.payementStatus,
      'payment_method': instance.paymentMethod,
      'payment_info': instance.paymentInfo,
    };
