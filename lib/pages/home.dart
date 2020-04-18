import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sparring/i18n.dart';
import 'package:sparring/pages/bookings/bookings.dart';
import 'package:sparring/pages/court/court_page.dart';
import 'package:sparring/pages/opponents/opponents_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    CourtPage(),
    OpponentsPage(),
    BookingsPage(),
    Text(
      'Account Page',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.futbol),
            title: Text(I18n.of(context).court),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.running),
            title: Text(I18n.of(context).opponent),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.calendarAlt),
            title: Text(I18n.of(context).booking),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.userAlt),
            title: Text(I18n.of(context).account),
          ),
        ],
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black45,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showUnselectedLabels: false,
      ),
    );
  }
}
