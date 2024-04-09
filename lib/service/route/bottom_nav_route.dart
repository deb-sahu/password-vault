import 'package:password_vault/constants/common_exports.dart';
import 'package:password_vault/feature/home/home.dart';
import 'package:password_vault/feature/passwords/passwords.dart';
import 'package:password_vault/feature/settings/settings.dart';
import 'package:password_vault/feature/history/history.dart';
import 'package:password_vault/feature/widget_utils/custom_icon.dart';
import 'package:flutter/cupertino.dart';

class NavRoute extends StatefulWidget {
  final int selectedIndex; // Add selectedIndex property

 const NavRoute({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NavRouteState createState() => _NavRouteState();
}

class _NavRouteState extends State<NavRoute> {
  late int _selectedIndex;

  static final List<Widget> _widgetOptions = <Widget>[
    const Home(),
    const Passwords(),
    const History(),
    const Settings()
    // Add your other page widgets here
  ];

    @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex; // Initialize _selectedIndex from widget property
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: CustomIcon(
            selectedIcon: CupertinoIcons.house_alt_fill,
            unselectedIcon: CupertinoIcons.house_alt,
            isSelected: _selectedIndex == 0,
          ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIcon(
            selectedIcon: CupertinoIcons.checkmark_shield_fill,
            unselectedIcon: CupertinoIcons.checkmark_shield,
            isSelected: _selectedIndex==1
            ),
            label: 'Passwords',
          ),
          BottomNavigationBarItem(
            icon: CustomIcon(
            selectedIcon: CupertinoIcons.timer_fill,
            unselectedIcon: CupertinoIcons.timer,
            isSelected: _selectedIndex==2
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: CustomIcon(
            selectedIcon: CupertinoIcons.gear_alt_fill,
            unselectedIcon: CupertinoIcons.gear_alt,
            isSelected: _selectedIndex==3
            ),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColor.appColor,
        unselectedItemColor: AppColor.blackColor,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppStyles.bottomNavSelectedText(context), 
        unselectedLabelStyle: AppStyles.bottomNavUnselectedText(context), 
        onTap: _onItemTapped,
      ),
    );
  }
}
