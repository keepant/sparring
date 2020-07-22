import 'package:empty_widget/empty_widget.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/components/loading.dart';
import 'package:sparring/components/sparring_card.dart';
import 'package:sparring/graphql/sparring.dart';
import 'package:sparring/graphql/users.dart';
import 'package:sparring/pages/sparring/sparring_detail.dart';
import 'package:sparring/services/auth.dart';
import 'package:sparring/services/prefs.dart';
import 'package:intl/intl.dart';

class UpcomingSparring extends StatefulWidget {
  @override
  _UpcomingSparringState createState() => _UpcomingSparringState();
}

class _UpcomingSparringState extends State<UpcomingSparring> {
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
    return _userId == null
        ? Loading()
        : GraphQLProvider(
            client: API.client,
            child: Query(
              options: QueryOptions(
                  documentNode: gql(getUserData),
                  pollInterval: 1,
                  variables: {
                    'id': _userId,
                  }),
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

                var teamId = result.data['users'][0]['team']['id'];

                return Query(
                  options: QueryOptions(
                      documentNode: gql(getAllSparring),
                      pollInterval: 10,
                      variables: {
                        'team': teamId,
                        'status': 'upcoming',
                      }),
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

                    if (result.data['sparring'].length == 0) {
                      return EmptyListWidget(
                        title: 'No sparring',
                        subTitle: 'No upcoming sparring available yet',
                        image: null,
                        packageImage: PackageImage.Image_4,
                      );
                    }

                    return ListView.builder(
                      itemCount: result.data['sparring'].length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var sparring = result.data['sparring'][index];
                        var team1 = result.data['sparring'][index]['team1'];
                        var team2 = result.data['sparring'][index]['team2'];

                        return SparringCard(
                          onTap: () {
                            pushNewScreen(
                              context,
                              screen: SparringDetail(
                                id: sparring['id'],
                                teamId: teamId,
                              ),
                              platformSpecific: false,
                              withNavBar: false,
                            );
                          },
                          team1Name: team1['name'],
                          team1Logo: team1['logo'],
                          team2Name: team2['name'],
                          team2Logo: team2['logo'],
                          date: new DateFormat.yMMMMd('en_US')
                              .format(DateTime.parse(sparring['date']))
                              .toString(),
                          timeStart: new DateFormat.Hm()
                              .format(DateTime.parse(sparring['date'] +
                                  ' ' +
                                  sparring['time_start']))
                              .toString(),
                          timeEnd: new DateFormat.Hm()
                              .format(DateTime.parse(sparring['date'] +
                                  ' ' +
                                  sparring['time_end']))
                              .toString(),
                          court: sparring['location'],
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
  }
}
