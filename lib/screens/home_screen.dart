
import 'package:exshange/screens/add_item_screen.dart';
import 'package:exshange/screens/chat_screen.dart';
import 'package:exshange/screens/item_overview_screen.dart';
import 'package:exshange/screens/liked_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final screens = [
    ItemOverviewScreen(),
    LikedScreen(),
    ChatScreen(),
    LikedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
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
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Liked',
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
      floatingActionButton: _currentIndex == 0 ? FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddItemScreen().routeName);
        },
        child: Icon(Icons.add),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
