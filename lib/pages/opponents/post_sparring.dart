import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.widget.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/components/loading.dart';
import 'package:sparring/graphql/bookings.dart';
import 'package:sparring/graphql/sparring.dart';
import 'package:sparring/graphql/users.dart';
import 'package:sparring/pages/more/team/add_team.dart';
import 'package:sparring/pages/utils/env.dart';
import 'package:sparring/services/auth.dart';
import 'package:sparring/services/prefs.dart';
import 'package:intl/intl.dart';

class PostSparring extends StatefulWidget {
  final ScrollController scrollController;
  final String userId;

  PostSparring({
    Key key,
    this.scrollController,
    this.userId,
  }) : super(key: key);

  @override
  _PostSparringState createState() => _PostSparringState();
}

class _PostSparringState extends State<PostSparring> {
  int _selectedIndex;

  String get updateSelfieAndAccountStatus => null;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          automaticallyImplyLeading: false,
          middle: Text("Pick court to post sparring"),
          trailing: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        child: GraphQLProvider(
          client: API.client,
          child: Query(
            options: QueryOptions(
              documentNode: gql(getUserData),
              pollInterval: 1,
              variables: {
                'id': widget.userId,
              },
            ),
            builder: (QueryResult result,
                {FetchMore fetchMore, VoidCallback refetch}) {
              if (result.loading) {
                return Loading();
              }

              if (result.exception.toString().contains(
                  "Could not verify JWT: JWTExpired: Undefined location")) {
                return FlatButton(
                  child: Text("Logout"),
                  onPressed: () async {
                    final auth = new Auth();
                    await auth.signOut();

                    await prefs.clearToken();

                    OneSignal.shared.removeExternalUserId();

                    Navigator.of(context).popUntil(ModalRoute.withName("/"));

                    Flushbar(
                      message: "Logout successfully!",
                      margin: EdgeInsets.all(8),
                      borderRadius: 8,
                      duration: Duration(seconds: 4),
                    )..show(context);
                  },
                );
              }

              if (result.hasException) {
                print(result.exception.toString());
                return Center(
                  child: Text(result.exception.toString()),
                );
              }

              var teamId = result.data['users'][0]['team'];

              return teamId == null
                  ? emptyTeam()
                  : Query(
                      options: QueryOptions(
                        documentNode: gql(getAllBookings),
                        pollInterval: 10,
                        variables: {
                          'status': 'upcoming',
                        },
                      ),
                      builder: (QueryResult result,
                          {FetchMore fetchMore, VoidCallback refetch}) {
                        if (result.loading) {
                          return Loading();
                        }

                        if (result.hasException) {
                          print(result.exception.toString());
                          return Center(
                            child: Text(result.exception.toString()),
                          );
                        }
                        if (result.data['bookings'].length == 0) {
                          return EmptyListWidget(
                            title: 'No bookings',
                            subTitle: 'Make booking court to post sparring!',
                            image: null,
                            packageImage: PackageImage.Image_4,
                          );
                        }

                        return Container(
                          padding: EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
                          child: ListView.builder(
                            itemCount: result.data['bookings'].length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var booking = result.data['bookings'][index];
                              var court = booking['court'];
                              var img = court['court_images'][0];

                              return Mutation(
                                  options: MutationOptions(
                                    documentNode: gql(insertSparring),
                                    update: (Cache cache, QueryResult result) {
                                      return cache;
                                    },
                                    onCompleted: (dynamic resultData) {
                                      print(resultData);
                                      Flushbar(
                                        message: "Sparring successfully saved!",
                                        margin: EdgeInsets.all(8),
                                        borderRadius: 8,
                                        duration: Duration(seconds: 2),
                                      )..show(context);
                                      // Navigator.of(context)
                                      //     .popUntil(ModalRoute.withName("/"));
                                    },
                                    onError: (error) => print(error),
                                  ),
                                  builder: (RunMutation runMutation,
                                      QueryResult result) {
                                    return InkWell(
                                      onTap: () {
                                        _onSelected(index);
                                        print(court['name']);
                                        AwesomeDialog(
                                          context: context,
                                          useRootNavigator: true,
                                          animType: AnimType.SCALE,
                                          dialogType: DialogType.INFO,
                                          btnOkOnPress: () {
                                            print(
                                                "date: ${booking['date']}\ntime: ${booking['time_start']} - ${booking['time_end']}\nteam: ${teamId['id']}\ncourt: ${court['id']}");
                                            runMutation({
                                              'date': booking['date'],
                                              'time_start':
                                                  booking['time_start'],
                                              'time_end': booking['time_end'],
                                              'team_id': teamId['id'],
                                              'court_id': court['id'],
                                            });
                                            Flushbar(
                                              message: "Finishing...",
                                              showProgressIndicator: true,
                                              margin: EdgeInsets.all(8),
                                              borderRadius: 8,
                                            )..show(context);
                                          },
                                          btnOkText: "Yes, I pick this court",
                                          btnOkColor:
                                              Theme.of(context).primaryColor,
                                          body: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 20.0),
                                                child: Text(
                                                  "Choose this court?",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 120,
                                                height: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    image: DecorationImage(
                                                      image: FirebaseImage(
                                                        fbCourtURI +
                                                            img['name'],
                                                      ),
                                                      fit: BoxFit.fill,
                                                    )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    Text(
                                                      court['name'],
                                                      style: TextStyle(
                                                        fontSize: 21.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      "on " +
                                                          new DateFormat.yMMMMd(
                                                                  'en_US')
                                                              .format(DateTime
                                                                  .parse(booking[
                                                                      'date']))
                                                              .toString(),
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      new DateFormat.Hm()
                                                              .format(DateTime
                                                                  .parse(booking[
                                                                          'date'] +
                                                                      ' ' +
                                                                      booking[
                                                                          'time_start']))
                                                              .toString() +
                                                          " - " +
                                                          new DateFormat.Hm()
                                                              .format(DateTime
                                                                  .parse(booking[
                                                                          'date'] +
                                                                      ' ' +
                                                                      booking[
                                                                          'time_end']))
                                                              .toString(),
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )..show();
                                      },
                                      child: Card(
                                        color: _selectedIndex != null &&
                                                _selectedIndex == index
                                            ? Colors.grey[300]
                                            : Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0, horizontal: 12.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                court['name'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(4.0),
                                                        child: Icon(
                                                          FontAwesomeIcons
                                                              .calendarAlt,
                                                          size: 14.0,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(4.0),
                                                        child: Text(new DateFormat
                                                                .yMMMMd('en_US')
                                                            .format(DateTime
                                                                .parse(booking[
                                                                    'date']))
                                                            .toString()),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(4.0),
                                                        child: Icon(
                                                          FontAwesomeIcons
                                                              .clock,
                                                          size: 14.0,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(4.0),
                                                        child: Text(
                                                          new DateFormat.Hm()
                                                                  .format(DateTime.parse(booking[
                                                                          'date'] +
                                                                      ' ' +
                                                                      booking[
                                                                          'time_start']))
                                                                  .toString() +
                                                              " - " +
                                                              new DateFormat
                                                                      .Hm()
                                                                  .format(DateTime.parse(booking[
                                                                          'date'] +
                                                                      ' ' +
                                                                      booking[
                                                                          'time_end']))
                                                                  .toString(),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ),
                        );
                      },
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget emptyTeam() {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/img/team.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "You don\'t have any team yet!",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        FontAwesomeIcons.solidTimesCircle,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50.0),
                  child: Text(
                    "Add your team to begin sparring",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, height: 1.6),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 50.0),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          margin: EdgeInsets.only(bottom: 30.0),
                          width: size.width - 50.0,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(180.0),
                          ),
                          child: Text(
                            "Add team now!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                        onTap: () {
                          pushNewScreen(
                            context,
                            screen: AddTeam(),
                            withNavBar: false,
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
