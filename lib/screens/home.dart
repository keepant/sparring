import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sparring/i18n.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Court Page',
    ),
    Text(
      'Opponents',
    ),
    Text(
      'Bookings',
    ),
    Text(
      'Notifications',
    ),
    Text(
      'Account',
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
      appBar: AppBar(
        title: Text(I18n.of(context).title),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.futbol),
            title: Text('Court'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.running),
            title: Text('Opponents'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.calendarAlt),
            title: Text('Bookings'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.bell),
            title: Text('Notifications'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.userAlt),
            title: Text('Account'),
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
