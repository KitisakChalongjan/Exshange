import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../models/offer.dart';
import '../../providers/authentication.dart';

class MyPendingDetailScreen extends StatefulWidget {
  const MyPendingDetailScreen({super.key});

  final routeName = '/mypendingdetail';

  @override
  State<MyPendingDetailScreen> createState() => _MyPendingDetailScreenState();
}

class _MyPendingDetailScreenState extends State<MyPendingDetailScreen> {
  @override
  Widget build(BuildContext context) {
    var offer = ModalRoute.of(context)!.settings.arguments as Offer;
    var user = context.read<Authentication>().currentUser!;
    return Scaffold();
  }
}
