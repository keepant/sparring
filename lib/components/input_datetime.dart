import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InputDateTime extends StatelessWidget {
  final String hintText;
  final DateFormat format;
  final DateTime initialValue;
  final IconData icon;
  final TextEditingController textEditingController;
  final Future<DateTime> Function(BuildContext context, DateTime currentValue)
      onShowPicker;
  final String warningText;

  InputDateTime({
    Key key,
    @required this.format,
    @required this.onShowPicker,
    @required this.textEditingController,
    this.hintText,
    this.icon,
    this.initialValue,
    this.warningText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: DateTimeField(
          validator: (value) => value == null ? warningText : null,
          initialValue: initialValue,
          controller: textEditingController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            hintText: hintText,
            prefixIcon: Icon(
              icon,
              color: Colors.blueGrey[300],
            ),
            hintStyle: TextStyle(
              fontSize: 15.0,
              color: Colors.blueGrey[300],
            ),
          ),
          format: format,
          onShowPicker: onShowPicker),
    );
  }
}
