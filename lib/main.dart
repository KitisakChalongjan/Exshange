import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/items.dart';
import 'package:exshange/providers/user_data.dart';
import 'package:exshange/screens/add_address_screen.dart';
import 'package:exshange/screens/add_item_screen.dart';
import 'package:exshange/screens/filter_screen.dart';
import 'package:exshange/screens/home_screen.dart';
import 'package:exshange/screens/item_detail_screen.dart';
import 'package:exshange/screens/login_screen.dart';
import 'package:exshange/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(
        //   create: (ctx) => Auth(),
        // ),
        ChangeNotifierProvider<Authentication>(
          create: (ctx) => Authentication(),
        ),
        StreamProvider<User?>(
          create: (ctx) => ctx.read<Authentication>().authStateChange,
          initialData: null,
        ),
        ChangeNotifierProvider<Items>(
          create: (ctx) => Items(),
        ),
        ChangeNotifierProvider<UserData>(
          create: (ctx) => UserData(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Exshange Project',
        theme: ThemeData(
          fontFamily: 'MitrRegular',
          primarySwatch: Colors.deepOrange,
          accentColor: Color(0xFF1DD6B0),
          backgroundColor: Color(0xFFF4F0EF),
          textTheme: const TextTheme(
            headline1: TextStyle(
              fontSize: 28,
              color: Color(0xFFF4F0EF),
              decoration: TextDecoration.none,
            ),
            headline2: TextStyle(
              fontSize: 28,
              color: Color(0xFF000000),
              decoration: TextDecoration.none,
            ),
            bodyText1: TextStyle(
              fontSize: 20,
              color: Color(0xFF000000),
              decoration: TextDecoration.none,
            ),
            bodyText2: TextStyle(
              fontSize: 20,
              color: Color(0xFFFFFFFF),
              decoration: TextDecoration.none,
            ),
            subtitle1: TextStyle(
              fontSize: 16,
              color: Color(0xFFFFFFFF),
              decoration: TextDecoration.none,
            ),
            subtitle2: TextStyle(
              fontSize: 16,
              color: Color(0xFF000000),
              decoration: TextDecoration.none,
            ),
            caption: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 80, 80, 80),
              decoration: TextDecoration.none,
            ),
          ),
        ),
        home: Authenticate(),
        // StreamBuilder(
        //   stream: Authentication().authStateChange,
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return CircularProgressIndicator();
        //     } else if (snapshot.hasData) {
        //       return HomeScreen();
        //     } else {
        //       return LoginScreen();
        //     }
        //   },
        // ),
        // ----------------------------------------------------------------
        // ? HomeScreen()
        // : FutureBuilder(
        //     future: auth.tryAutoLogin(),
        //     builder: (ctx, authResultSnapshot) =>
        //         authResultSnapshot.connectionState ==
        //                 ConnectionState.waiting
        //             ? SplashScreen()
        //             : LoginScreen(),
        //   ),
        initialRoute: '/',
        routes: {
          FilterScreen().routeName: (context) => FilterScreen(),
          AddItemScreen().routeName: (context) => AddItemScreen(),
          AddAdressScreen().routeName: (context) => AddAdressScreen(),
          ItemDetailScreen().routeName: (context) => ItemDetailScreen(),
        },
      ),
    );
  }
}

class Authenticate extends StatelessWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = Provider.of<User?>(context);
    if (firebaseUser != null) {
      return HomeScreen();
    }
    return LoginScreen();
  }
}
