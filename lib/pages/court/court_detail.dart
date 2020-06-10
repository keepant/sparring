import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/components/loading.dart';
import 'package:sparring/components/text_style.dart';
import 'package:sparring/graphql/search_court.dart';

class CourtDetail extends StatefulWidget {
  final int id;

  CourtDetail({Key key, this.id}) : super(key: key);

  @override
  _CourtDetailState createState() => _CourtDetailState();
}

class _CourtDetailState extends State<CourtDetail>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: API.client,
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
              physics: ScrollPhysics(),
              itemCount: result.data['court'].length,
              itemBuilder: (context, index) {
                var court = result.data['court'][index];
                var img = result.data['court'][index]['court_images'][0];

                return Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(img['name']),
                      ),
                    ),
                    Positioned(
                      left: 5,
                      top: 25,
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
                      top: 250.0,
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
                                Tab(text: "Review"),
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
                                      BoldText("About", 20.0, Colors.black),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      NormalText(
                                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea. ",
                                          Colors.black,
                                          12.0),
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          equipmentsItem(Icons.wifi, "Wi-Fi"),
                                          equipmentsItem(
                                              Icons.local_parking, "Parking"),
                                          equipmentsItem(Icons.pool, "Pool"),
                                          equipmentsItem(
                                              Icons.restaurant, "Restaurant"),
                                        ],
                                      )
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
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: Image.network(
                                            "https://i.ibb.co/Fs6N59X/plazamap.png",
                                            fit: BoxFit.fill,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                90,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          BoldText(
                                              "Reviews", 20.0, Colors.black),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                width: 50.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.white,
                                                      size: 15.0,
                                                    ),
                                                    BoldText("4.5", 15.0,
                                                        Colors.white),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              NormalText("(420 reviews)",
                                                  Colors.grey, 14),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          reviewProfile(
                                              "Hichem", "5.0", "05,Mar,2020"),
                                          reviewProfile(
                                              "Walid", "3.5", "17,feb,2020"),
                                          reviewProfile(
                                              "kratos", "4.0", "10,jan,2020"),
                                        ],
                                      ),
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
                    Container(),
                  ],
                );
              },
            ),
            bottomNavigationBar: RaisedButton(
              onPressed: () {},
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

  Column equipmentsItem(IconData icon, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(icon, color: Colors.blue),
        NormalText(text, Colors.blue, 12)
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }
}
