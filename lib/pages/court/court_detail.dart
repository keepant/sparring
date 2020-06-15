import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/components/loading.dart';
import 'package:sparring/components/text_style.dart';
import 'package:sparring/graphql/search_court.dart';
import 'package:sparring/pages/court/payment.dart';

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
        NormalText(text, Colors.blue, 12)
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
                var img = result.data['court'][index]['court_images'][0];
                var fasility = result.data['court'][index]['court_facilities'];

                return Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          img['name'],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 5,
                      top: 10,
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
                                  fontWeight: FontWeight.bold),
                              controller: tabController,
                              indicatorColor: Colors.blue,
                              tabs: <Widget>[
                                Tab(text: "Overview"),
                                Tab(text: "Location"),
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
                                          court['name'], 20.0, Colors.black),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.grey,
                                            size: 15.0,
                                          ),
                                          NormalText(court['address'],
                                              Colors.grey, 15.0),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      NormalText(
                                          "Rp." +
                                              court['price_per_hour']
                                                  .toString() +
                                              " per hour",
                                          Colors.black,
                                          16.0),
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
                                          "Description", 20.0, Colors.black),
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
                                                child: NormalText("Open day",
                                                    Colors.black, 15.0),
                                              ),
                                              Container(
                                                child: NormalText(
                                                    court['open_day'] +
                                                        " - " +
                                                        court['closed_day'],
                                                    Colors.black,
                                                    15.0),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                child: NormalText("Open hours",
                                                    Colors.black, 15.0),
                                              ),
                                              Container(
                                                child: NormalText(
                                                  court['open_hour'] +
                                                      " - " +
                                                      court['closed_hour'],
                                                  Colors.black,
                                                  15.0,
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
                                          "Facilities", 20.0, Colors.black),
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
                                                    fasility[index]['name']),
                                              );
                                            }),
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
                                            "Location", 20.0, Colors.black),
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
                    qty: 2,
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
                "Book now",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget reviewProfile(String name, String review, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 24,
              height: 24,
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  size: 12,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            BoldText(name, 16, Colors.black)
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Container(
              width: 50.0,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 15.0,
                  ),
                  BoldText(review, 15.0, Colors.white),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            NormalText(date, Colors.grey, 12.0)
          ],
        ),
        SizedBox(
          height: 10,
        ),
        NormalText(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
            Colors.black,
            12.0),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
