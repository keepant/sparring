import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/components/loading.dart';
import 'package:sparring/graphql/sparring.dart';
import 'package:sparring/i18n.dart';
import 'package:sparring/pages/utils/env.dart';
import 'package:sparring/pages/utils/navigation.dart';

class SparringDetail extends StatelessWidget {
  final int id;
  final String teamId;

  SparringDetail({
    Key key,
    this.id,
    this.teamId,
  }) : super(key: key);

  Color getColorStatus(String status) {
    if (status == 'completed') {
      return Colors.green;
    } else if (status == 'upcoming') {
      return Colors.blue;
    }

    return Colors.red;
  }

  IconData getIconStatus(String status) {
    if (status == 'completed') {
      return FontAwesomeIcons.solidCalendarCheck;
    } else if (status == 'upcoming') {
      return FontAwesomeIcons.calendarDay;
    }

    return FontAwesomeIcons.solidCalendarTimes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).oppDetailText),
      ),
      body: GraphQLProvider(
        client: API.client,
        child: Query(
          options: QueryOptions(
              documentNode: gql(getSparringDetail),
              pollInterval: 1,
              variables: {
                'id': id,
              }),
          builder: (QueryResult result,
              {FetchMore fetchMore, VoidCallback refetch}) {
            if (result.loading) {
              return Loading();
            }

            if (result.hasException) {
              return Center(
                child: Text(result.exception.toString()),
              );
            }

            var sparring = result.data['sparring'][0];
            var team1 = sparring['team1'];
            var team2 = sparring['team2'];
            var user1 = team1['users'][0];
            var user2 = team2['users'][0];
            var court = sparring['court'];

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                image: team1['logo'] == null ||
                                        team1['logo'] == ''
                                    ? AssetImage("assets/img/default_logo.png")
                                    : FirebaseImage(
                                        fbTeamLogoURI + team1['logo'],
                                      ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                          child: Text(
                            team1['name'],
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/icon/versus.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                image: team2['logo'] == null ||
                                        team2['logo'] == ''
                                    ? AssetImage("assets/img/default_logo.png")
                                    : FirebaseImage(
                                        fbTeamLogoURI + team2['logo'],
                                      ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                          child: Text(
                            team2['name'],
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Divider(
                  height: 2.0,
                  thickness: 1.0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Icon(
                          getIconStatus(sparring['status']),
                          color: getColorStatus(sparring['status']),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          sparring['status'].toUpperCase(),
                          style: TextStyle(
                            color: getColorStatus(sparring['status']),
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 2.0,
                  thickness: 1.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 8.0),
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
                            child: Text(sparring['date']),
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
                                "${sparring['time_start']} - ${sparring['time_end']}"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 2.0,
                  thickness: 1.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.only(top: 4.0, left: 8.0, bottom: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.location_on,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              court['name'],
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        MapsLauncher.launchCoordinates(
                            double.parse(court['latitude']),
                            double.parse(court['longitude']));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          I18n.of(context).seeLocationText,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
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
                    I18n.of(context).oppInfoText,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
                teamId != team1['id']
                    ? TeamInfo(
                        teamLogo: team1['logo'],
                        teamName: team1['name'],
                        teamLoaction: team1['address'],
                        captain: user1['name'],
                        address: user1['address'],
                        phoneNumber: user1['phone_number'],
                        profilePicture: user1['profile_picture'],
                      )
                    : TeamInfo(
                        teamLogo: team2['logo'],
                        teamName: team2['name'],
                        teamLoaction: team2['address'],
                        captain: user2['name'],
                        address: user2['address'],
                        phoneNumber: user2['phone_number'],
                        profilePicture: user2['profile_picture'],
                      )
              ],
            );
          },
        ),
      ),
    );
  }
}

class TeamInfo extends StatelessWidget {
  final String teamLogo;
  final String teamName;
  final String teamLoaction;
  final String captain;
  final String profilePicture;
  final String phoneNumber;
  final String address;

  TeamInfo({
    Key key,
    @required this.teamLoaction,
    @required this.teamLogo,
    @required this.teamName,
    @required this.captain,
    @required this.profilePicture,
    @required this.address,
    @required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: teamLogo == null || teamLogo == ''
                      ? AssetImage("assets/img/default_logo.png")
                      : FirebaseImage(
                          fbTeamLogoURI + teamLogo,
                        ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(I18n.of(context).teamNameText),
              Text(
                teamName,
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
                teamLoaction,
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
                captain,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 4.0),
          child: Text(
            I18n.of(context).capInfoText,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: profilePicture == null || profilePicture == ''
                      ? AssetImage("assets/img/pp.png")
                      : FirebaseImage(
                          fbProfileUserURI + profilePicture,
                        ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(I18n.of(context).nameText),
              Text(
                captain,
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
              Text(I18n.of(context).addressText),
              Text(
                address ?? "-",
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
              Text(I18n.of(context).phoneNumberText),
              Text(
                phoneNumber ?? "-",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        phoneNumber == null || phoneNumber == ''
            ? Container()
            : Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigation.launchURL("http://wa.me/$phoneNumber");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.whatsapp,
                        color: Hexcolor("#25d366"),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Whatsapp",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Hexcolor("#25d366"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}
