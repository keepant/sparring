import 'package:flutter/material.dart';

class CourtCard extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String location;
  final String price;
  final GestureTapCallback onTap;

  CourtCard({
    this.imgUrl,
    this.title,
    this.location,
    this.price,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 130,
        child: Card(
          elevation: 1,
          child: Padding(
            padding: EdgeInsets.all(1.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imgUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 8.0, top: 8.0, bottom: 2.0),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 2.0),
                                child: Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(
                                location,
                                style: TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.normal,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0, top: 20),
                          child: Text(
                            "Rp."+ price + " per hour",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
