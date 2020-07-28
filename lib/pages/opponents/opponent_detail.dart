import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/components/loading.dart';
import 'package:sparring/graphql/sparring.dart';
import 'package:sparring/graphql/users.dart';
import 'package:sparring/i18n.dart';
import 'package:sparring/pages/sparring/sparring.dart';
import 'package:sparring/pages/utils/env.dart';
import 'package:sparring/pages/utils/utils.dart';

class OpponentDetail extends StatefulWidget {
  final int id;
  final String opTeamId;

  OpponentDetail({
    Key key,
    this.id,
    this.opTeamId,
  }) : super(key: key);

  @override
  _OpponentDetailState createState() => _OpponentDetailState();
}

class _OpponentDetailState extends State<OpponentDetail> {
  SharedPreferences sharedPreferences;
  String _userId;

  _getUserId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _userId = (sharedPreferences.getString("userId") ?? '');
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).opponentDetailText),
      ),
      bottomNavigationBar: GraphQLProvider(
        client: API.client,
        child: Query(
          options: QueryOptions(
            documentNode: gql(getUserData),
            pollInterval: 1,
            variables: {
              'id': _userId,
            },
          ),
          builder: (QueryResult result,
              {FetchMore fetchMore, VoidCallback refetch}) {
            if (result.loading) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
              );
            }

            if (result.hasException) {
              return Center(child: Text(result.exception.toString()));
            }

            var teamId = result.data['users'];

            return Mutation(
              options: MutationOptions(
                documentNode: gql(insertOpponent),
                update: (Cache cache, QueryResult result) {
                  return cache;
                },
                onCompleted: (dynamic resultData) {
                  print(resultData);

                  pushNewScreen(
                    context,
                    screen: Sparring(),
                    withNavBar: false,
                  );

                  Flushbar(
                    message: I18n.of(context).makeSparringText,
                    margin: EdgeInsets.all(8),
                    borderRadius: 8,
                    duration: Duration(seconds: 2),
                  )..show(context);
                },
                onError: (error) => print(error),
              ),
              builder: (RunMutation runMutation, QueryResult result) {
                return RaisedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(I18n.of(context).pickOpponentText),
                          content:
                              Text(I18n.of(context).pickOpponentConfirmText),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                I18n.of(context).cancelText,
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              splashColor: Theme.of(context).primaryColor,
                              child: Text(
                                I18n.of(context).sureText,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15.0,
                                ),
                              ),
                              onPressed: () {
                                if (teamId[0]['team']['id'] ==
                                    widget.opTeamId) {
                                  Navigator.of(context).pop();
                                  AwesomeDialog(
                                    autoHide: Duration(seconds: 2),
                                    context: context,
                                    useRootNavigator: true,
                                    animType: AnimType.SCALE,
                                    dialogType: DialogType.INFO,
                                    title: "Oppss",
                                    desc:
                                        I18n.of(context).alertSelfSparringText,
                                  )..show();
                                } else {
                                  runMutation({
                                    'id': widget.id,
                                    'team': teamId[0]['team']['id'],
                                  });
                                  Navigator.of(context).pop();
                                  Flushbar(
                                    message: I18n.of(context).makeSparringText,
                                    showProgressIndicator: true,
                                    margin: EdgeInsets.all(8),
                                    borderRadius: 8,
                                    duration: Duration(seconds: 2),
                                  )..show(context);
                                }
                              },
                            )
                          ],
                        );
                      },
                    );
                  },
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    I18n.of(context).pickOpponentText,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                );
              },
            );
          },
        ),
      ),
      body: GraphQLProvider(
        client: API.client,
        child: Query(
          options: QueryOptions(
            documentNode: gql(getAvailableSparringDetail),
            pollInterval: 1,
            variables: {
              'id': widget.id,
            },
          ),
          builder: (QueryResult result,
              {FetchMore fetchMore, VoidCallback refetch}) {
            if (result.loading) {
              return Loading();
            }

            if (result.hasException) {
              return Center(child: Text(result.exception.toString()));
            }

            var sparring = result.data['sparring'][0];
            var team = sparring['team1'];
            var user = team['users'][0];
            var court = sparring['court'];
            var courtImg = court['court_images'];

            return Column(
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
                          borderRadius: BorderRadius.circular(15.0),
                          image: DecorationImage(
                            image: FirebaseImage(
                              fbTeamLogoURI + team['logo'],
                            ),
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
                          padding: EdgeInsets.only(left: 8.0, top: 8.0),
                          child: Text(
                            team['name'],
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Icon(
                                      FontAwesomeIcons.calendarAlt,
                                      size: 14.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(formatDate(sparring['date'])),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Icon(
                                      FontAwesomeIcons.clock,
                                      size: 14.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                        "${formatTime(sparring['time_start'])} - ${formatTime(sparring['time_end'])}"),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0, top: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 2.0),
                                child: Icon(
                                  Icons.location_on,
                                  size: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(
                                court['name'],
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Container(height: 10.0, color: Colors.black12),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 4.0),
                  child: Text(
                    I18n.of(context).opponent,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(I18n.of(context).teamNameText),
                          Text(
                            team['name'],
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(I18n.of(context).teamLocationText),
                          Text(
                            team['address'],
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(I18n.of(context).teamCaptainText),
                          Text(
                            user['name'],
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 0.0),
                      child: Text(
                        I18n.of(context).captainText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            backgroundImage: user['profile_picture'] == '' ||
                                    user['profile_picture'] == null
                                ? AssetImage("assets/img/pp.png")
                                : FirebaseImage(
                                    fbProfileUserURI + user['profile_picture'],
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  user['name'],
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      size: 15.0,
                                    ),
                                    SizedBox(width: 5.0),
                                    Text(
                                      user['address'],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 2.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0),
                      child: Text(
                        I18n.of(context).court,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: Carousel(
                          autoplay: false,
                          borderRadius: true,
                          animationCurve: Curves.fastOutSlowIn,
                          animationDuration: Duration(milliseconds: 1000),
                          dotSize: 3.0,
                          dotIncreasedColor: Theme.of(context).primaryColor,
                          dotBgColor: Colors.transparent,
                          dotPosition: DotPosition.bottomCenter,
                          dotVerticalPadding: 7.0,
                          showIndicator: true,
                          indicatorBgPadding: 5.0,
                          images: [
                            FirebaseImage(fbCourtURI + courtImg[0]['name']),
                            FirebaseImage(fbCourtURI + courtImg[1]['name']),
                            FirebaseImage(fbCourtURI + courtImg[2]['name'])
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            court['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: Theme.of(context).primaryColor,
                                size: 16.0,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                court['address'],
                              ),
                            ],
                          ),
                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              MapsLauncher.launchCoordinates(
                                double.parse(court['latitude']),
                                double.parse(court['longitude']),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                I18n.of(context).seeLocationText,
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
