import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/graphql/team.dart';
import 'package:sparring/i18n.dart';
import 'package:sparring/pages/more/team/team.dart';
import 'package:sparring/pages/utils/env.dart';
import 'package:uuid/uuid.dart';

class AddTeam extends StatefulWidget {
  @override
  _AddTeamState createState() => _AddTeamState();
}

class _AddTeamState extends State<AddTeam> {
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

  final TextEditingController _nameTxt = new TextEditingController();
  final TextEditingController _addressTxt = new TextEditingController();

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  File _image;
  final _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  final FirebaseStorage _storage = FirebaseStorage(
    storageBucket: fbStorageURI,
  );

  StorageUploadTask uploadTask;

  var uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    print(uuid.v4().toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          I18n.of(context).addTeamText,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: GraphQLProvider(
        client: API.client,
        child: FormBuilder(
          key: _fbKey,
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            children: <Widget>[
              FormBuilderTextField(
                attribute: "name",
                decoration: InputDecoration(labelText: I18n.of(context).teamNameText),
                controller: _nameTxt,
                validators: [
                  FormBuilderValidators.required(),
                ],
              ),
              FormBuilderTextField(
                attribute: "address",
                decoration: InputDecoration(labelText: I18n.of(context).teamLocationText),
                controller: _addressTxt,
                validators: [
                  FormBuilderValidators.required(),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(I18n.of(context).teamLogoText),
              IconButton(
                icon: Icon(
                  Icons.add_a_photo,
                  size: 30,
                ),
                onPressed: () {
                  getImage();
                },
              ),
              _image == null
                  ? Text(I18n.of(context).noImageSelectedText)
                  : Image.file(
                      _image,
                      width: 300,
                      height: 200,
                    ),
              SizedBox(
                height: 10,
              ),
              Mutation(
                  options: MutationOptions(
                    documentNode: gql(addTeam),
                    update: (Cache cache, QueryResult result) {
                      return cache;
                    },
                    onCompleted: (dynamic resultData) {
                      print(resultData);
                      pushNewScreen(
                        context,
                        screen: Team(
                          userId: _userId,
                        ),
                        platformSpecific: true,
                        withNavBar: true,
                      );
                      Flushbar(
                        message: I18n.of(context).teamSavedText,
                        margin: EdgeInsets.all(8),
                        borderRadius: 8,
                        duration: Duration(seconds: 2),
                      )..show(context);
                    },
                    onError: (error) => print(error),
                  ),
                  builder: (RunMutation runMutation, QueryResult result) {
                    return RaisedButton(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        I18n.of(context).saveText,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        String name = _nameTxt.text;
                        String fileName = "$name-logo-${DateTime.now()}.png";
                        String imgTrim = fileName.replaceAll(" ", "");
                        String logoPath = 'team_logo/$imgTrim';

                        setState(() {
                          uploadTask =
                              _storage.ref().child(logoPath).putFile(_image);
                        });

                        runMutation({
                          'team_id': uuid.v4(),
                          'name': name,
                          'address': _addressTxt.text,
                          'id': _userId,
                          'logo': imgTrim,
                        });

                        print(
                            "name: $name\naddress: ${_addressTxt.text}\nlogo: $imgTrim");

                        if (_fbKey.currentState.validate()) {
                          FocusScope.of(context).unfocus();
                          Flushbar(
                            message: I18n.of(context).savingTeamText,
                            showProgressIndicator: true,
                            margin: EdgeInsets.all(8),
                            borderRadius: 8,
                          )..show(context);
                        }
                      },
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
