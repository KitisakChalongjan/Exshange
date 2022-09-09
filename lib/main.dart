import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/items.dart';
import 'package:exshange/screens/add_item_screen.dart';
import 'package:exshange/screens/filter_screen.dart';
import 'package:exshange/screens/home_screen.dart';
import 'package:exshange/screens/login_screen.dart';
import 'package:exshange/screens/splash_screen.dart';
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
        ChangeNotifierProvider(
          create: (ctx) => Items(),
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
          ),
        ),
        home: StreamBuilder(
          stream: Authentication().authStateChange,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          },
        ),
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
        },
      ),
    );
  }
}
