import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/items.dart';
import 'package:exshange/providers/user_data.dart';
import 'package:exshange/screens/home/add_item_screen.dart';
import 'package:exshange/screens/chat/chat_screen.dart';
import 'package:exshange/screens/home/item_overview_screen.dart';
import 'package:exshange/screens/recommend/recommend_screen.dart';
import 'package:exshange/screens/profile/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  final routeName = '/home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? currentUser = Authentication().currentUser;

  int _currentIndex = 0;
  final screens = [
    ItemOverviewScreen(),
    RecommendScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    print('build homescreen');
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Exshange'),
    //     actions: [
    //       GestureDetector(
    //         child: Icon(Icons.logout_rounded),
    //         onTap: () {
    //           Navigator.of(context).pushReplacementNamed('/');
    //           Provider.of<Auth>(context, listen: false).logout();
    //         },
    //       ),
    //     ],
    //   ),
    // );
    return Scaffold(
      body: IndexedStack(
        children: screens,
        index: _currentIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        selectedFontSize: 16,
        unselectedItemColor: Color(0xFFcccccc),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            print(_currentIndex);
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Recommend',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Me',
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddItemScreen().routeName);
              },
              child: Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
