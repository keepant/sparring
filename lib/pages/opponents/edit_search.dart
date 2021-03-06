import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparring/components/input_datetime.dart';
import 'package:sparring/components/input_text.dart';
import 'package:sparring/i18n.dart';
import 'package:intl/intl.dart';
import 'package:sparring/pages/opponents/opponents_result.dart';

class EditSearch extends StatelessWidget {
  final ScrollController scrollController;
  final String location;
  final String date;
  final String time;

  const EditSearch({Key key, this.scrollController, this.location, this.date, this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _locationControl = new TextEditingController();
    final TextEditingController _dateControl = new TextEditingController();
    final TextEditingController _timeControl = new TextEditingController();

    final dateFormat = DateFormat("yyyy-MM-dd");
    final timeFormat = DateFormat.Hm();
    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: Container(),
          middle: Text(I18n.of(context).editSearchText),
          trailing: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
                child: InputText(
                  hintText: I18n.of(context).hintLocationCourtTextField,
                  icon: FontAwesomeIcons.mapMarkerAlt,
                  textEditingController: _locationControl..text = location,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: InputDateTime(
                  textEditingController: _dateControl..text = date,
                  format: dateFormat,
                  hintText: I18n.of(context).hintDateTextField,
                  icon: FontAwesomeIcons.calendarAlt,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      initialDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: InputDateTime(
                  textEditingController: _timeControl..text = time,
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

                    FocusScope.of(context).unfocus();

                    pushNewScreen(
                      context,
                      screen: OpponentsResult(
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
                    I18n.of(context).doneText,
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
