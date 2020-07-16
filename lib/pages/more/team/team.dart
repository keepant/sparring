import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.widget.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/components/loading.dart';
import 'package:sparring/graphql/team.dart';
import 'package:sparring/pages/more/team/add_team.dart';

class Team extends StatefulWidget {
  final String userId;

  Team({
    Key key,
    this.userId,
  }) : super(key: key);

  @override
  _TeamState createState() => _TeamState();
}

class _TeamState extends State<Team> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Team",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).popUntil(ModalRoute.withName("/"));
          },
        ),
      ),
      body: GraphQLProvider(
        client: API.client,
        child: Query(
          options: QueryOptions(
            documentNode: gql(getTeam),
            pollInterval: 5,
            variables: {
              'id': widget.userId,
            },
          ),
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

            var team = result.data['team'];

            return team.length < 1 ? emptyTeam() : Container();
          },
        ),
      ),
    );
  }

  Widget emptyTeam() {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        color: Color(0xfff1eefc),
      ),
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
