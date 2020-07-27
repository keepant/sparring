import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparring/components/input_datetime.dart';
import 'package:sparring/components/input_text.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:sparring/i18n.dart';
import 'package:sparring/pages/court/search_result.dart';
import 'package:sparring/pages/opponents/opponents_page.dart';

class CourtPage extends StatefulWidget {
  @override
  _CourtPageState createState() => _CourtPageState();
}

class _CourtPageState extends State<CourtPage> {
  final TextEditingController _locationControl = new TextEditingController();
  final TextEditingController _dateControl = new TextEditingController();
  final TextEditingController _timeControl = new TextEditingController();

  static final dateFormat = DateFormat('yyyy-MM-dd');
  static final timeFormat = DateFormat.Hm();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
         gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue, Colors.redAccent],
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
                        color: Colors.white,
                        size: 18.0,
                      ),
                      onPressed: () {},
                      label: Text(
                        I18n.of(context).court,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                      color: Theme.of(context).primaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 13.0),
                      autofocus: true,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    FlatButton.icon(
                      icon: FaIcon(
                        FontAwesomeIcons.running,
                        color: Colors.white70,
                        size: 18.0,
                      ),
                      onPressed: () {
                        pushNewScreen(
                          context,
                          screen: OpponentsPage(),
                          platformSpecific: false,
                          withNavBar: true,
                        );
                      },
                      label: Text(
                        I18n.of(context).opponent,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white70,
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
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
                        child: InputText(
                          warningText: 'Location cannot be empty!',
                          hintText: I18n.of(context).hintLocationCourtTextField,
                          icon: FontAwesomeIcons.mapMarkerAlt,
                          textEditingController: _locationControl,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: InputDateTime(
                          warningText: 'Date cannot be empty!',
                          textEditingController: _dateControl
                            ..text =
                                dateFormat.format(DateTime.now()).toString(),
                          format: dateFormat,
                          icon: FontAwesomeIcons.calendarAlt,
                          onShowPicker: (context, currentValue) {
                            return showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              initialDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 30)),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: InputDateTime(
                          warningText: 'Time cannot be empty!',
                          textEditingController: _timeControl
                            ..text =
                                timeFormat.format(DateTime.now()).toString(),
                          format: timeFormat,
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
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(20.0),
                        child: RaisedButton(
                          onPressed: () {
                            print("loc: " + _locationControl.text);
                            print("date: " + _dateControl.text);
                            print("time: " + _timeControl.text);

                            FocusScope.of(context).unfocus();
    
                            pushNewScreen(
                              context,
                              screen: SearchResult(
                                location: _locationControl.text,
                                date: _dateControl.text,
                                time: _timeControl.text,
                              ),
                              platformSpecific: false,
                              withNavBar: false,
                            );
                          },
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            I18n.of(context).searchText,
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
