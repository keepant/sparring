import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sparring/components/input_datetime.dart';
import 'package:sparring/components/input_text.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bg/bg-1.jpg'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 20.0, top: 50.0),
                child: Text(
                  "Book futsal court \nand find opponents",
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => CourtPage(),
                        //   ),
                        // );
                      },
                      label: Text(
                        "Court",
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
                        "Opponents",
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
                  hintText: "E.g: Solo or Sritex",
                  icon: FontAwesomeIcons.mapMarkerAlt,
                  textEditingController: _locationControl,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: InputDateTime(
                  textEditingController: _dateControl,
                  format: dateFormat,
                  hintText: "Date",
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
                  hintText: "Time",
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
                    "Search",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
