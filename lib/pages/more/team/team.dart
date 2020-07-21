import 'package:firebase_image/firebase_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.widget.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/components/loading.dart';
import 'package:sparring/graphql/team.dart';
import 'package:sparring/pages/more/team/add_team.dart';
import 'package:sparring/pages/more/team/crop_image.dart';
import 'package:sparring/pages/utils/env.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController _nameTxt = new TextEditingController();
  final TextEditingController _addressTxt = new TextEditingController();
  final TextEditingController _createdTxt = new TextEditingController();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  final _picker = ImagePicker();

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

            var team = result.data['users'][0]['team'];

            return team == null
                ? emptyTeam()
                : FormBuilder(
                    key: _fbKey,
                    child: ListView(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 15.0, top: 8.0),
                          child: Center(
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              child: Stack(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 50,
                                    backgroundImage: team['logo'] == null ||
                                            team['logo'] == ''
                                        ? AssetImage(
                                            "assets/img/default_logo.png")
                                        : FirebaseImage(
                                            fbTeamLogoURI + team['logo'],
                                          ),
                                  ),
                                  Positioned(
                                    top: 70,
                                    right: 0,
                                    bottom: 40.0,
                                    left: 75,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.black,
                                      size: 25.0,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                final pickedFile = await _picker.getImage(source: ImageSource.gallery);

                                pushNewScreen(
                                  context,
                                  screen: CropImage(
                                    file: pickedFile.path,
                                    name: team['name'],
                                    userId: widget.userId,
                                    id: team['id'],
                                  ),
                                  withNavBar: false,
                                );
                              },
                            ),
                          ),
                        ),
                        FormBuilderTextField(
                          attribute: "name",
                          decoration: InputDecoration(labelText: "Team name"),
                          controller: _nameTxt..text = team['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                          validators: [
                            FormBuilderValidators.required(),
                          ],
                        ),
                        FormBuilderTextField(
                          attribute: "address",
                          decoration:
                              InputDecoration(labelText: "Team base location"),
                          controller: _addressTxt..text = team['address'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                          validators: [
                            FormBuilderValidators.required(),
                          ],
                        ),
                        FormBuilderTextField(
                          readOnly: true,
                          attribute: "created",
                          decoration: InputDecoration(labelText: "Created"),
                          controller: _createdTxt
                            ..text = new DateFormat.yMMMMd('en_US')
                                .format(DateTime.parse(team['created_at']))
                                .toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Mutation(
                          options: MutationOptions(
                            documentNode: gql(updateTeam),
                            update: (Cache cache, QueryResult result) {
                              return cache;
                            },
                            onCompleted: (dynamic resultData) {
                              print(resultData);
                              Flushbar(
                                message: "Data saved!",
                                margin: EdgeInsets.all(8),
                                borderRadius: 8,
                                duration: Duration(seconds: 2),
                              )..show(context);
                            },
                            onError: (error) => print(error),
                          ),
                          builder:
                              (RunMutation runMutation, QueryResult result) {
                            return RaisedButton(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              color: Theme.of(context).primaryColor,
                              child: Text(
                                "Update",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                String name = _nameTxt.text;

                                runMutation({
                                  'name': name,
                                  'address': _addressTxt.text,
                                  'id': team['id'],
                                });

                                print(
                                    "name: $name\naddress: ${_addressTxt.text}\n");

                                if (_fbKey.currentState.validate()) {
                                  FocusScope.of(context).unfocus();
                                  Flushbar(
                                    message: "Saving update..",
                                    showProgressIndicator: true,
                                    margin: EdgeInsets.all(8),
                                    borderRadius: 8,
                                  )..show(context);
                                }
                              },
                            );
                          },
                        )
                      ],
                    ),
                  );
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
