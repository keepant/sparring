import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/components/loading.dart';
import 'package:intl/intl.dart';
import 'package:sparring/graphql/users.dart';

class Profile extends StatefulWidget {
  final String userId;
  final String sex;

  Profile({
    Key key,
    this.userId,
    this.sex,
  }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _nameTxt = new TextEditingController();
  final TextEditingController _emailTxt = new TextEditingController();
  final TextEditingController _phoneTxt = new TextEditingController();
  final TextEditingController _addressTxt = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _picked;

  @override
  void initState() {
    super.initState();
    _picked = widget.sex;
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: API.client,
      child: Query(
        options: QueryOptions(
            documentNode: gql(getUserData),
            variables: {
              'id': widget.userId,
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

          var user = result.data['users'][0];

          // _picked = user['sex'] ?? '';

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                "Profile",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              elevation: 0,
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, top: 8.0),
                    child: Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: user['profile_picture'] == '' || user['profile_picture'] == null
                            ? AssetImage("assets/img/pp.png")
                            : NetworkImage(user['profile_picture']),
                      ),
                    ),
                  ),
                  EditView(
                    label: "Name",
                    textEditingController: _nameTxt..text = user['name'],
                    keyboardType: TextInputType.text,
                    hintText: "Full name",
                    warningText: "Name cannot be empty!",
                  ),
                  EditView(
                    label: "Email",
                    textEditingController: _emailTxt..text = user['email'],
                    keyboardType: TextInputType.emailAddress,
                    hintText: "Email",
                    warningText: "Email cannot be empty!",
                    enabled: false,
                  ),
                  _radioBtn(),
                  EditView(
                    label: "Phone number",
                    textEditingController: _phoneTxt
                      ..text = user['phone_number'],
                    keyboardType: TextInputType.number,
                    hintText: "Phone number",
                    warningText: "Phone number cannot be empty!",
                  ),
                  EditView(
                    label: "Address",
                    textEditingController: _addressTxt..text = user['address'],
                    keyboardType: TextInputType.text,
                    hintText: "Address",
                    warningText: "Address cannot be empty!",
                  ),
                  FieldView(
                    label: "Joined",
                    text: new DateFormat.yMMMMd('en_US')
                        .format(DateTime.parse(user['created_at']))
                        .toString(),
                    useDivider: false,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Mutation(
                      options: MutationOptions(
                        documentNode: gql(updateUser),
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
                      builder: (RunMutation runMutation, QueryResult result) {
                        return RaisedButton(
                          onPressed: () {
                            print("name: " +
                                _nameTxt.text +
                                "\nemail: " +
                                _emailTxt.text +
                                "\nsex: " +
                                _picked +
                                "\nphone number: " +
                                _phoneTxt.text +
                                "\naddress: " +
                                _addressTxt.text);

                            if (_formKey.currentState.validate()) {
                              runMutation({
                                'id': widget.userId,
                                'name': _nameTxt.text,
                                'sex': _picked,
                                'phone': _phoneTxt.text,
                                'address': _addressTxt.text
                              });
                              FocusScope.of(context).unfocus();
                              Flushbar(
                                message: "Saving changes..",
                                showProgressIndicator: true,
                                margin: EdgeInsets.all(8),
                                borderRadius: 8,
                                duration: Duration(seconds: 2),
                              )..show(context);
                            }
                          },
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _radioBtn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text("Sex"),
        ),
        RadioButtonGroup(
          orientation: GroupedButtonsOrientation.HORIZONTAL,
          onSelected: (String selected) => setState(() {
            _picked = selected;
          }),
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
          activeColor: Theme.of(context).primaryColor,
          labels: <String>[
            "Laki-laki",
            "Perempuan",
          ],
          picked: _picked,
          itemBuilder: (Radio rb, Text txt, int i) {
            return Row(
              children: <Widget>[
                rb,
                txt,
              ],
            );
          },
        ),
      ],
    );
  }
}

class EditView extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController textEditingController;
  final String warningText;
  final TextInputType keyboardType;
  final bool enabled;

  EditView({
    @required this.label,
    this.hintText,
    this.textEditingController,
    this.warningText,
    this.keyboardType,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(label),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: TextFormField(
            enabled: enabled,
            controller: textEditingController,
            keyboardType: keyboardType,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
            validator: (value) => value.isEmpty ? warningText : null,
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText,
              hintStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FieldView extends StatelessWidget {
  final String label;
  final String text;
  final bool useDivider;

  FieldView({
    @required this.label,
    @required this.text,
    this.useDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
          child: Text(label),
        ),
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
        ),
        useDivider ? Divider() : Container(),
      ],
    );
  }
}
