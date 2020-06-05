import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparring/i18n.dart';
import 'package:sparring/pages/accounts/me.dart';
import 'package:sparring/pages/bookings/bookings.dart';
import 'package:sparring/pages/court/court_page.dart';
import 'package:sparring/services/auth_check.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      CourtPage(),
      BookingsPage(),
      AuthCheck(),
      Me(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: "Home",
        activeColor: Colors.deepOrange,
        activeContentColor: Colors.white,
        inactiveColor: Colors.grey,
        isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: FaIcon(FontAwesomeIcons.calendarAlt),
        title: I18n.of(context).booking,
        activeColor: Colors.deepOrange,
        activeContentColor: Colors.white,
        inactiveColor: Colors.grey,
        isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: FaIcon(FontAwesomeIcons.running),
        title: "Match",
        activeColor: Colors.deepOrange,
        activeContentColor: Colors.white,
        inactiveColor: Colors.grey,
        isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: FaIcon(FontAwesomeIcons.userAlt),
        title: I18n.of(context).account,
        activeColor: Colors.deepOrange,
        activeContentColor: Colors.white,
        inactiveColor: Colors.grey,
        isTranslucent: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      showElevation: true,
      navBarCurve: NavBarCurve.upperCorners,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: false,
      onItemSelected: (index) {
        print(index);
      },
      itemCount: 4,
      navBarStyle: NavBarStyle.style7,
    );
  }
}
