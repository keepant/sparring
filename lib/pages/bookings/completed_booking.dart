import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sparring/components/booking_card.dart';

class CompletedBooking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      controller: ScrollController(keepScrollOffset: true),
      itemBuilder: (context, index) {
        return BookingCard(
          imgUrl:
              "https://ecs7.tokopedia.net/img/cache/700/product-1/2019/3/17/2905360/2905360_bc8d6026-bb5c-4920-bacd-a7b4bb1f9f6b_576_576.jpg",
          title: "Lapangan Baru Jadi",
          location: "Surakarta, Indonesia",
          date: "26 Juni",
          time: "5 PM",
          icon: FaIcon(
            FontAwesomeIcons.solidCalendarCheck,
            color: Colors.green,
          ),
          status: "Completed",
          color: Colors.green,
        );
      },
    );
  }
}
