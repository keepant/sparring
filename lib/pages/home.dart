import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparring/pages/court/court_page.dart';
import 'package:sparring/pages/more/more.dart';
import 'package:sparring/pages/notifications/notifications.dart';
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
      AuthCheck(),
      NotificationPage(),
      More(),
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
        icon: Icon(Icons.calendar_today),
        title: "History",
        activeColor: Colors.deepOrange,
        activeContentColor: Colors.white,
        inactiveColor: Colors.grey,
        isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.notifications),
        title: "Notifications",
        activeColor: Colors.deepOrange,
        activeContentColor: Colors.white,
        inactiveColor: Colors.grey,
        isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.menu),
        title: "More",
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
