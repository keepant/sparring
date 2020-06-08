import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparring/components/court_card.dart';

class BestMatch extends StatelessWidget {
  final int id;

  BestMatch({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return CourtCard(
          imgUrl:
              "https://ecs7.tokopedia.net/img/cache/700/product-1/2019/3/17/2905360/2905360_bc8d6026-bb5c-4920-bacd-a7b4bb1f9f6b_576_576.jpg",
          title: "Lapangan",
          location: "Surakarta",
          onTap: () {

          },
        );
      },
    );
  }
}
