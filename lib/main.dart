import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/providers/categories.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/filter.dart';
import 'package:exshange/providers/items.dart';
import 'package:exshange/providers/messages.dart';
import 'package:exshange/providers/offers.dart';
import 'package:exshange/providers/user_data.dart';
import 'package:exshange/screens/chat/chat_message_screen.dart';
import 'package:exshange/screens/chat/chat_user_info.dart';
import 'package:exshange/screens/home/add_address_screen.dart';
import 'package:exshange/screens/home/add_item_screen.dart';
import 'package:exshange/screens/home/donate_screen.dart';
import 'package:exshange/screens/home/item_overview_screen.dart';
import 'package:exshange/screens/home/offer_screen.dart';
import 'package:exshange/screens/profile/edit_address_screen.dart';
import 'package:exshange/screens/profile/edit_profile_screen.dart';
import 'package:exshange/screens/home/filter_screen.dart';
import 'package:exshange/screens/home_screen.dart';
import 'package:exshange/screens/home/item_detail_screen.dart';
import 'package:exshange/screens/login_screen.dart';
import 'package:exshange/screens/profile/my_address_screen.dart';
import 'package:exshange/screens/profile/my_category.dart';
import 'package:exshange/screens/profile/my_deal_detail_screen.dart';
import 'package:exshange/screens/profile/my_deal_screen.dart';
import 'package:exshange/screens/profile/my_history_detail_screen.dart';
import 'package:exshange/screens/profile/my_history_screen.dart';
import 'package:exshange/screens/profile/my_item_detail_screen.dart';
import 'package:exshange/screens/profile/my_item_screen.dart';
import 'package:exshange/screens/profile/my_pending_detail_screen.dart';
import 'package:exshange/screens/profile/my_pending_screen.dart';
import 'package:exshange/screens/profile/profile_screen.dart';
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
        ChangeNotifierProvider(
          create: (ctx) => Offers(),
        ),
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
        ChangeNotifierProvider<Filter>(
          create: (ctx) => Filter(),
        ),
        ChangeNotifierProvider<Categories>(
          create: (ctx) => Categories(),
        ),
        ChangeNotifierProvider<Messages>(
          create: (ctx) => Messages(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Exshange Project',
        theme: ThemeData(
          fontFamily: 'MitrRegular',
          primarySwatch: Colors.deepOrange,
          accentColor: Color(0xFF1DD6B0),
          errorColor: Colors.red,
          primaryColorLight: Color(0xFFFF916A),
          focusColor: Color(0xFF4BD9BC),
          hintColor: Color.fromARGB(255, 80, 80, 80),
          backgroundColor: Color(0xFFF4F0EF),
          disabledColor: Color.fromARGB(255, 151, 208, 154),
          splashColor: Color.fromARGB(255, 238, 137, 137),
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
              color: Color.fromARGB(255, 110, 110, 110),
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
          Authenticate().routeName: (context) => Authenticate(),
          FilterScreen().routeName: (context) => FilterScreen(),
          AddItemScreen().routeName: (context) => AddItemScreen(),
          AddAdressScreen().routeName: (context) => AddAdressScreen(),
          ItemDetailScreen().routeName: (context) => ItemDetailScreen(),
          EditProfileScreen().routeName: (context) => EditProfileScreen(),
          MyItemsScreen().routeName: (context) => MyItemsScreen(),
          MyHistoryScreen().routeName: (context) => MyHistoryScreen(),
          MyHistoryDetailScreen().routeName: (context) =>
              MyHistoryDetailScreen(),
          MyDealScreen().routeName: (context) => MyDealScreen(),
          MyCategoriesScreen().routeName: (context) => MyCategoriesScreen(),
          MyAddressScreen().routeName: (context) => MyAddressScreen(),
          OfferScreen().routeName: (context) => OfferScreen(),
          DonateScreen().routeName: (context) => DonateScreen(),
          EditAddressScreen().routeName: (context) => EditAddressScreen(),
          MyDealDetailScreen().routeName: (context) => MyDealDetailScreen(),
          ProfileScreen().routeName: (context) => ProfileScreen(),
          HomeScreen().routeName: (context) => HomeScreen(),
          MyItemDetailScreen().routeName: (context) => MyItemDetailScreen(),
          ChatMessageScreen().routeName: (context) => ChatMessageScreen(),
          ChatUserInfo().routeName: (context) => ChatUserInfo(),
          ItemOverviewScreen().routeName: (context) => ItemOverviewScreen(),
          MyPendingScreen().routeName: (context) => MyPendingScreen(),
          MyPendingDetailScreen().routeName: (context) =>
              MyPendingDetailScreen(),
        },
      ),
    );
  }
}

class Authenticate extends StatelessWidget {
  const Authenticate({Key? key}) : super(key: key);
  final routeName = '/authenticate';

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      return FutureBuilder(
        future: Future.wait([
          context.read<Items>().initItemsData(),
          context.read<UserData>().fetchUserData(firebaseUser.uid),
          context.read<Categories>().fetchCategories(),
        ]),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return HomeScreen();
          }
        }),
      );
    }
    return LoginScreen();
  }
}
