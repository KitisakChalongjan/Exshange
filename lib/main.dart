import 'package:exshange/providers/auth.dart';
import 'package:exshange/screens/item_overview.dart';
import 'package:exshange/screens/login_screen.dart';
import 'package:exshange/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Exshange Project',
          theme: ThemeData(
            fontFamily: 'MitrRegular',
            primarySwatch: Colors.deepOrange,
            accentColor: Color(0xFF1DD6B0),
            backgroundColor: Color(0xFFF4F0EF),
            textTheme: const TextTheme(
              headline1: TextStyle(
                fontSize: 32,
                color: Color(0xFFF4F0EF),
              ),
              headline2: TextStyle(
                fontSize: 28,
                color: Color(0xFF000000),
              ),
              headline3: TextStyle(
                fontSize: 24,
                color: Color(0xFF000000),
              ),
              bodyText1: TextStyle(
                fontSize: 20,
                color: Color(0xFF000000),
              ),
              bodyText2: TextStyle(
                fontSize: 20,
                color: Color(0xFF555555),
              ),
              subtitle1: TextStyle(
                fontSize: 20,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
          home: auth.isAuth
              ? ItemOverview()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : LoginScreen(),
                ),
        ),
      ),
    );
  }
}
