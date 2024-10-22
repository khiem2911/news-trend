import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/provider/user_provider.dart';
import 'package:news_app/screens/explore.dart';
import 'package:news_app/screens/home.dart';
import 'package:news_app/screens/profile.dart';
import 'package:news_app/screens/saved.dart';

class TabsScreen extends ConsumerStatefulWidget {
  TabsScreen({super.key, this.userData});

  Map<String, dynamic>? userData;

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreen();
  }
}

class _TabsScreen extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    ref.read(UserProvider.notifier).getUser(widget.userData);
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const HomeScreen();

    switch (_selectedPageIndex) {
      case 0:
        activePage = const HomeScreen();
      case 1:
        activePage = const Explore();
      case 2:
        activePage = const SavedScreen();
      case 3:
        activePage = const ProfileScreen();
    }

    return Scaffold(
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.orange,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.5),
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Save'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: 'Profile'),
          ]),
    );
  }
}
