import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparring/components/input_datetime.dart';
import 'package:sparring/components/input_text.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:sparring/i18n.dart';
import 'package:sparring/pages/court/court_page.dart';
import 'package:sparring/pages/opponents/post_sparring.dart';
import 'package:flutter/cupertino.dart';

class OpponentsPage extends StatefulWidget {
  @override
  _OpponentsPageState createState() => _OpponentsPageState();
}

class _OpponentsPageState extends State<OpponentsPage> {
  final TextEditingController _locationControl = new TextEditingController();
  final TextEditingController _dateControl = new TextEditingController();
  final TextEditingController _timeControl = new TextEditingController();

  final dateFormat = DateFormat("dd MMMM");
  final timeFormat = DateFormat("h:mm");

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
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue, Colors.red],
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 20.0, top: 50.0),
                child: Text(
                  I18n.of(context).headerTextPage,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton.icon(
                      icon: FaIcon(
                        FontAwesomeIcons.futbol,
                        color: Colors.white70,
                        size: 18.0,
                      ),
                      onPressed: () {
                        pushNewScreen(
                          context,
                          screen: CourtPage(),
                          platformSpecific: false,
                          withNavBar: true,
                        );
                      },
                      label: Text(
                        I18n.of(context).court,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white70,
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 13.0),
                      autofocus: true,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    FlatButton.icon(
                      color: Theme.of(context).primaryColor,
                      icon: FaIcon(
                        FontAwesomeIcons.running,
                        color: Colors.white,
                        size: 18.0,
                      ),
                      onPressed: () {},
                      label: Text(
                        I18n.of(context).opponent,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 13.0),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                  height: 2.0,
                  thickness: 2.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
                child: InputText(
                  hintText: I18n.of(context).hintLocationCourtTextField,
                  icon: FontAwesomeIcons.mapMarkerAlt,
                  textEditingController: _locationControl,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: InputDateTime(
                  textEditingController: _dateControl,
                  format: dateFormat,
                  hintText: I18n.of(context).hintDateTextField,
                  icon: FontAwesomeIcons.calendarAlt,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: InputDateTime(
                  textEditingController: _timeControl,
                  format: timeFormat,
                  hintText: I18n.of(context).hintTimeTextField,
                  icon: FontAwesomeIcons.clock,
                  onShowPicker: (context, currentValue) async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.convert(time);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: RaisedButton(
                  onPressed: () {
                    print("loc: " + _locationControl.text);
                    print("date: " + _dateControl.text);
                    print("time: " + _timeControl.text);
                  },
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    I18n.of(context).searchText,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
              ),
              _postSparring(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _postSparring() {
    return Column(
      children: <Widget>[
        _divider(I18n.of(context).orText),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20.0),
          child: RaisedButton.icon(
            onPressed: () {
              showCupertinoModalBottomSheet(
                expand: true,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context, scrollController) => PostSparring(
                  scrollController: scrollController,
                  userId: _userId,
                ),
              );
            },
            padding: EdgeInsets.symmetric(vertical: 15.0),
            color: Colors.deepOrange,
            icon: Icon(
              FontAwesomeIcons.running,
              color: Colors.white,
            ),
            label: Text(
              "Post sparring",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _divider(String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
