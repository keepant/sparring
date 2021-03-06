import 'package:firebase_image/firebase_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/components/text_style.dart';
import 'package:sparring/graphql/users.dart';
import 'package:sparring/i18n.dart';
import 'package:sparring/pages/more/about.dart';
import 'package:sparring/pages/more/profile/profile.dart';
import 'package:sparring/pages/more/team/team.dart';
import 'package:sparring/pages/utils/env.dart';
import 'package:sparring/services/auth.dart';
import 'package:sparring/services/auth/profile.dart';
import 'package:sparring/services/prefs.dart';

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  SharedPreferences sharedPreferences;
  String _userId;

  Future<void> _getUserId() async {
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
        title: Text(
          I18n.of(context).profileText,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 21.0,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _getUserId,
        child: SingleChildScrollView(
          child: _userId == null || _userId == ''
              ? _emptyUser()
              : GraphQLProvider(
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
                        return _userShimmer();
                      }

                      if (result.exception.toString().contains(
                              "ClientException: Unhandled Failure Invalid argument(s)") ||
                          result.exception.toString().contains(
                              "Could not verify JWT: JWTExpired: Undefined location")) {
                        return _emptyUser();
                      }

                      if (result.hasException) {
                        return Center(
                          child: Text(result.exception.toString()),
                        );
                      }

                      var user = result.data['users'][0];

                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 50,
                                  backgroundImage:
                                      user['profile_picture'] == '' ||
                                              user['profile_picture'] == null
                                          ? AssetImage("assets/img/pp.png")
                                          : FirebaseImage(
                                              fbProfileUserURI +
                                                  user['profile_picture'],
                                            ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      BoldText(
                                        text: user['name'],
                                        size: 20.0,
                                        color: Colors.black,
                                      ),
                                      NormalText(
                                        text: user['email'],
                                        color: Colors.grey,
                                        size: 17.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          _profileItem(
                            icon: FontAwesomeIcons.userAlt,
                            text: I18n.of(context).myInfoText,
                            onTap: () {
                              pushNewScreen(
                                context,
                                screen: Profile(
                                  userId: _userId,
                                  sex: user['sex'],
                                ),
                                platformSpecific: false,
                                withNavBar: false,
                              );
                            },
                          ),
                          _profileItem(
                              icon: FontAwesomeIcons.userFriends,
                              text: I18n.of(context).myTeamText,
                              onTap: () {
                                pushNewScreen(
                                  context,
                                  screen: Team(
                                    userId: _userId,
                                  ),
                                  platformSpecific: false,
                                  withNavBar: false,
                                );
                              }),
                          _profileItem(
                              icon: FontAwesomeIcons.infoCircle,
                              text: I18n.of(context).aboutUsText,
                              onTap: () {
                                pushNewScreen(
                                  context,
                                  screen: AboutUs(),
                                  platformSpecific: false,
                                  withNavBar: false,
                                );
                              }),
                          _profileItem(
                            icon: FontAwesomeIcons.signOutAlt,
                            text: I18n.of(context).logoutText,
                            onTap: () async {
                              final auth = new Auth();
                              await auth.signOut();

                              await prefs.clearToken();

                              OneSignal.shared.removeExternalUserId();

                              Navigator.of(context)
                                  .popUntil(ModalRoute.withName("/"));

                              Flushbar(
                                message: I18n.of(context).logoutSuccessText,
                                margin: EdgeInsets.all(8),
                                borderRadius: 8,
                                duration: Duration(seconds: 4),
                              )..show(context);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Widget _profileItem({IconData icon, String text, GestureTapCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 6, top: 6),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: Colors.black54,
              size: 30,
            ),
            SizedBox(
              width: 15,
            ),
            NormalText(
              text: text,
              color: Colors.black,
              size: 20.0,
            )
          ],
        ),
      ),
    );
  }

  Widget _userShimmer() {
    return Shimmer.fromColors(
      highlightColor: Colors.grey[100],
      baseColor: Colors.grey[300],
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(radius: 50, backgroundColor: Colors.white),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 20,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 15,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Divider(
            thickness: 2,
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            height: 25,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 25,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 25,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 25,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyUser() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                  radius: 50, child: Image.asset('assets/img/unknown.png')),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    BoldText(
                      text: I18n.of(context).loginOrRegisterText,
                      size: 20.0,
                      color: Colors.black,
                    ),
                    FlatButton(
                      color: Colors.deepOrange[400],
                      onPressed: () {
                        pushNewScreen(
                          context,
                          screen: ProfileCheck(),
                          platformSpecific: false,
                          withNavBar: false,
                        );
                      },
                      child: Text(
                        I18n.of(context).loginText,
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Divider(
          thickness: 2,
        ),
        SizedBox(
          height: 5.0,
        ),
        _profileItem(
          icon: FontAwesomeIcons.userAlt,
          text: I18n.of(context).myInfoText,
          onTap: null,
        ),
        _profileItem(
          icon: FontAwesomeIcons.userFriends,
          text: I18n.of(context).myTeamText,
          onTap: null,
        ),
        _profileItem(
            icon: FontAwesomeIcons.infoCircle,
            text: I18n.of(context).aboutUsText,
            onTap: () {
              pushNewScreen(
                context,
                screen: AboutUs(),
                platformSpecific: false,
                withNavBar: false,
              );
            }),
        _profileItem(
          icon: FontAwesomeIcons.signInAlt,
          text: I18n.of(context).loginText,
          onTap: () async {
            pushNewScreen(
              context,
              screen: ProfileCheck(),
              platformSpecific: false,
              withNavBar: false,
            );
          },
        ),
      ],
    );
  }
}
