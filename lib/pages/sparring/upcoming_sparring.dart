import 'package:flutter/material.dart';
import 'package:sparring/components/sparring_card.dart';

class UpcomingSparring extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (contex, index) {
        return SparringCard(
          onTap: () {},
          team1Name: "Silent Night Team",
          team1Logo: "https://image.freepik.com/free-vector/e-sports-team-logo-template-with-ninja_23-2147830862.jpg",
          team2Name: "Samuari Team",
          team2Logo: "https://image.freepik.com/free-vector/e-sports-team-logo-with-samurai-head_113398-6.jpg",
          date: "July 17, 2020",
          timeStart: "20:00",
          timeEnd: "21:00",
          court: "Lapangan Randevous",
        );
      },
    );
  }
}
