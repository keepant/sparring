import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.widget.dart';
import 'package:simple_image_crop/simple_image_crop.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/graphql/team.dart';
import 'package:sparring/i18n.dart';
import 'package:sparring/pages/more/team/team.dart';
import 'package:sparring/pages/utils/env.dart';

class CropImage extends StatefulWidget {
  final String file;
  final String name;
  final String userId;
  final String id;

  CropImage({
    Key key,
    this.file,
    this.name,
    this.userId,
    this.id,
  }) : super(key: key);

  @override
  _CropImageState createState() => _CropImageState();
}

class _CropImageState extends State<CropImage> {
  final cropKey = GlobalKey<ImgCropState>();

  final FirebaseStorage _storage = FirebaseStorage(
    storageBucket: fbStorageURI,
  );

  StorageUploadTask uploadTask;

  @override
  Widget build(BuildContext context) {
    print(widget.file);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: widget.file != null
          ? Center(
              child: ImgCrop(
                chipShape: 'circle',
                chipRadius: 150,
                key: cropKey,
                maximumScale: 3,
                image: FileImage(File(widget.file)),
              ),
            )
          : Container(),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: GraphQLProvider(
          client: API.client,
          child: Mutation(
            options: MutationOptions(
              documentNode: gql(updateLogo),
              onCompleted: (dynamic resultData) {
                print(resultData);

                pushNewScreen(
                  context,
                  screen: Team(
                    userId: widget.userId,
                  ),
                  withNavBar: false,
                );

                Flushbar(
                  message: I18n.of(context).logoSavedText,
                  margin: EdgeInsets.all(8),
                  borderRadius: 8,
                  duration: Duration(seconds: 2),
                )..show(context);
              },
              onError: (error) => print(error),
            ),
            builder: (RunMutation runMutation, QueryResult result) {
              return RaisedButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                icon: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                label: Text(
                  I18n.of(context).saveText,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  final crop = cropKey.currentState;
                  final croppedFile = await crop.cropCompleted(
                    File(widget.file),
                    pictureQuality: 900,
                  );

                  String name = widget.name;
                  String fileName = "$name-logo-${DateTime.now()}.png";
                  String imgTrim = fileName.replaceAll(" ", "");
                  String logoPath = 'team_logo/$imgTrim';

                  runMutation({
                    'logo': imgTrim,
                    'id': widget.id,
                  });

                  setState(() {
                    uploadTask =
                        _storage.ref().child(logoPath).putFile(croppedFile);
                  });

                  print("new logo: $imgTrim");
                  Flushbar(
                    message: I18n.of(context).savingLogoText,
                    showProgressIndicator: true,
                    margin: EdgeInsets.all(8),
                    borderRadius: 8,
                  )..show(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
