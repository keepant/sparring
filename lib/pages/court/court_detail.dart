import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/components/loading.dart';
import 'package:sparring/components/text_style.dart';
import 'package:sparring/graphql/search_court.dart';
import 'package:sparring/i18n.dart';
import 'package:sparring/pages/court/court_hero.dart';
import 'package:sparring/pages/court/payment.dart';
import 'package:sparring/pages/utils/env.dart';
import 'package:sparring/pages/utils/utils.dart';

class CourtDetail extends StatefulWidget {
  final int id;
  final String name;
  final String lat;
  final String long;
  final String address;
  final String date;
  final String time;
  final int price;

  CourtDetail({
    Key key,
    this.id,
    this.name,
    this.lat,
    this.long,
    this.address,
    this.date,
    this.time,
    this.price,
  }) : super(key: key);

  @override
  _CourtDetailState createState() => _CourtDetailState();
}

class _CourtDetailState extends State<CourtDetail>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  GoogleMapController mapController;
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  IconData getIconFacilities(String text) {
    if (text == 'Parkir') {
      return FontAwesomeIcons.parking;
    } else if (text == 'Wifi') {
      return FontAwesomeIcons.wifi;
    } else if (text == 'Air minum') {
      return FontAwesomeIcons.cocktail;
    } else if (text == 'Toilet') {
      return FontAwesomeIcons.toilet;
    } else if (text == 'Bola') {
      return FontAwesomeIcons.futbol;
    } else if (text == 'Jersey') {
      return FontAwesomeIcons.tshirt;
    }

    return FontAwesomeIcons.smileBeam;
  }

  Column equipmentsItem(String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(getIconFacilities(text), color: Colors.blue),
        SizedBox(
          height: 5,
        ),
        NormalText(
          text: text,
          color: Colors.blue,
          size: 12,
        )
      ],
    );
  }

  @override
  void initState() {
    _markers.add(
      Marker(
        markerId: MarkerId("courtLoc"),
        position: LatLng(double.parse(widget.lat), double.parse(widget.long)),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: widget.name,
          snippet: widget.address,
        ),
      ),
    );

    super.initState();
    tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: API.guestClient,
      child: Query(
        options: QueryOptions(
            documentNode: gql(getCourt),
            pollInterval: 10,
            variables: {
              'id': widget.id,
            }),
        builder: (QueryResult result,
            {FetchMore fetchMore, VoidCallback refetch}) {
          if (result.loading) {
            return Loading();
          }

          if (result.hasException) {
            return Center(child: Text(result.exception.toString()));
          }

          return Scaffold(
            backgroundColor: Colors.white,
            body: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: result.data['court'].length,
              itemBuilder: (context, index) {
                var court = result.data['court'][index];
                var img = result.data['court'][index]['court_images'];
                var fasility =
                    result.data['court'][index]['court_facilities_pivots'];

                return Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourtHero(
                                  image: img,
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: "court-picture",
                            child: Carousel(
                              autoplay: true,
                              animationCurve: Curves.fastOutSlowIn,
                              animationDuration: Duration(milliseconds: 1000),
                              dotSize: 6.0,
                              dotIncreasedColor: Theme.of(context).primaryColor,
                              dotBgColor: Colors.transparent,
                              dotPosition: DotPosition.topCenter,
                              dotVerticalPadding: 10.0,
                              showIndicator: true,
                              indicatorBgPadding: 7.0,
                              images: [
                                FirebaseImage(fbCourtURI + img[0]['name']),
                                FirebaseImage(fbCourtURI + img[1]['name']),
                                FirebaseImage(fbCourtURI + img[2]['name'])
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 5,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).primaryColor,
                          size: 28,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Positioned(
                      top: 210.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 290,
                          child: Scaffold(
                            appBar: TabBar(
                              labelColor: Colors.blue,
                              labelStyle: TextStyle(
                                fontFamily: "nunito",
                                fontWeight: FontWeight.bold,
                              ),
                              controller: tabController,
                              indicatorColor: Colors.blue,
                              tabs: <Widget>[
                                Tab(text: I18n.of(context).overviewText),
                                Tab(text: I18n.of(context).locationText),
                              ],
                            ),
                            backgroundColor: Colors.white,
                            body: TabBarView(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      BoldText(
                                        text: court['name'],
                                        size: 20.0,
                                        color: Colors.black,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.grey,
                                            size: 15.0,
                                          ),
                                          NormalText(
                                            text: court['address'],
                                            color: Colors.grey,
                                            size: 15.0,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      NormalText(
                                        text:
                                            "${formatCurrency(court['price_per_hour'])} per hour",
                                        color: Colors.black,
                                        size: 16.0,
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Container(
                                        height: 2,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      BoldText(
                                          text:
                                              I18n.of(context).descriptionText,
                                          size: 20.0,
                                          color: Colors.black),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                child: NormalText(
                                                  text: I18n.of(context)
                                                      .openDayText,
                                                  color: Colors.black,
                                                  size: 15.0,
                                                ),
                                              ),
                                              Container(
                                                child: NormalText(
                                                    text:
                                                        "${court['open_day']} - ${court['closed_day']}",
                                                    color: Colors.black,
                                                    size: 15.0),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                child: NormalText(
                                                  text: I18n.of(context)
                                                      .openHourText,
                                                  color: Colors.black,
                                                  size: 15.0,
                                                ),
                                              ),
                                              Container(
                                                child: NormalText(
                                                  text:
                                                      "${court['open_hour']} - ${court['closed_hour']}",
                                                  color: Colors.black,
                                                  size: 15.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Container(
                                        height: 2,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      BoldText(
                                        text: I18n.of(context).facilitiesText,
                                        size: 20.0,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: fasility.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: equipmentsItem(
                                                  fasility[index]
                                                          ['court_facility']
                                                      ['name']),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        BoldText(
                                          text: I18n.of(context).locationText,
                                          size: 20.0,
                                          color: Colors.black,
                                        ),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              400,
                                          child: GoogleMap(
                                            onMapCreated: _onMapCreated,
                                            initialCameraPosition:
                                                CameraPosition(
                                              target: LatLng(
                                                double.parse(widget.lat),
                                                double.parse(widget.long),
                                              ),
                                              zoom: 15.0,
                                            ),
                                            markers: _markers,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              controller: tabController,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                    )
                  ],
                );
              },
            ),
            bottomNavigationBar: RaisedButton(
              onPressed: () {
                pushNewScreen(
                  context,
                  screen: Payment(
                    courtId: widget.id,
                    date: widget.date,
                    time: widget.time,
                    qty: 1,
                    name: widget.name,
                    price: widget.price,
                  ),
                  platformSpecific: false,
                  withNavBar: false,
                );
              },
              padding: EdgeInsets.symmetric(vertical: 15.0),
              color: Theme.of(context).primaryColor,
              child: Text(
                I18n.of(context).bookText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
