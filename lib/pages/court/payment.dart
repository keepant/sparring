import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:intl/intl.dart';

const CHANNEL = "com.keepant.sparring";
const KEY_NATIVE = "showPaymentGateway";

class Payment extends StatelessWidget {
  static const platform = const MethodChannel(CHANNEL);

  Future<Null> _showNativeView() async {
    await platform.invokeMethod(KEY_NATIVE, {
      "name": "Lapangan",
      "price": "20000",
      "qty": "1"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Payment details"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    "https://adhyasta.com/assets/images/3-lapangan-futsal.jpg"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
            child: Text(
              "Lapangan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  size: 15,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 3,
                ),
                Text("Address"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
            child: InkWell(
              child: Text(
                "See court details",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 13.0,
                ),
              ),
              onTap: () {},
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: FaIcon(
                        FontAwesomeIcons.calendarAlt,
                        size: 14.0,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(new DateFormat.yMMMMd('en_US')
                          .format(DateTime.parse('2020-06-01'))
                          .toString()),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: FaIcon(
                        FontAwesomeIcons.clock,
                        size: 14.0,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(new DateFormat.Hm()
                              .format(
                                  DateTime.parse('2020-06-01' + ' ' + '13:00'))
                              .toString() +
                          " - " +
                          new DateFormat.Hm()
                              .format(
                                  DateTime.parse('2020-06-01' + ' ' + '14:00'))
                              .toString()),
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Container(height: 10.0, color: Colors.black12),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
            child: Text(
              'Invoice',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(
                    "Total price",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  child: Text(
                    "Rp " + "25.000",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: RaisedButton(
        onPressed: () {
          _showNativeView();
        },
        padding: EdgeInsets.symmetric(vertical: 15.0),
        color: Theme.of(context).primaryColor,
        child: Text(
          "Checkout",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
    );
  }
}

