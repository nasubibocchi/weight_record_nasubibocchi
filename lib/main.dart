import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:weight_record_nasubibocchi/constants/const.dart';
import 'package:weight_record_nasubibocchi/model/symplemodel/dayModel.dart';
import 'package:weight_record_nasubibocchi/view/graphPage.dart';
import 'package:weight_record_nasubibocchi/view/userPage.dart';

import 'view/homePage.dart';
import 'view/recordPage.dart';



Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weight Record',
      home: MyHomePage(),
    );
  }
}


///initialPage
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return Tab();
        } else {
          return UserPage();
        }
      },
    );
  }
}

///navigation
class Tab extends StatelessWidget {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  final _dayModel = DayModel();

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      RecordPage(date: _dayModel.formattedDate(date: DateTime.now())),
      GraphPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.view_carousel_outlined),
        //title: '',
        activeColorPrimary: kBaseColour,
        inactiveColorPrimary: kAccentColour,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.note_add_outlined),
        //title: '',
        activeColorPrimary: kBaseColour,
        inactiveColorPrimary: kAccentColour,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.auto_graph_outlined),
        //title: '',
        activeColorPrimary: kBaseColour,
        inactiveColorPrimary: kAccentColour,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: kMainColour,
      // Default is Colors.white.
      handleAndroidBackButtonPress: true,
      // Default is true.
      // ignore: lines_longer_than_80_chars
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      // Default is true.
      // ignore: lines_longer_than_80_chars
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: kMainColour,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style6, // Choose the nav bar style with this property.
    );
  }
}
