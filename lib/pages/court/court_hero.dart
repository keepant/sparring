import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:sparring/pages/utils/env.dart';

class CourtHero extends StatelessWidget {
  final List image;

  CourtHero({
    Key key,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Hero(
        tag: "court-picture",
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 400.0,
            child: Carousel(
              autoplay: false,
              animationCurve: Curves.fastOutSlowIn,
              animationDuration: Duration(milliseconds: 1000),
              dotSize: 6.0,
              dotIncreasedColor: Theme.of(context).primaryColor,
              dotBgColor: Colors.transparent,
              dotPosition: DotPosition.bottomCenter,
              dotVerticalPadding: 10.0,
              showIndicator: true,
              indicatorBgPadding: 7.0,
              images: [
                FirebaseImage(fbCourtURI + image[0]['name']),
                FirebaseImage(fbCourtURI + image[1]['name']),
                FirebaseImage(fbCourtURI + image[2]['name'])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
