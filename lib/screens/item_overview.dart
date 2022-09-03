import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class ItemOverview extends StatefulWidget {
  const ItemOverview({Key? key}) : super(key: key);

  @override
  State<ItemOverview> createState() => _ItemOverviewState();
}

class _ItemOverviewState extends State<ItemOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exshange'),
        actions: [
          GestureDetector(
            child: Icon(Icons.logout_rounded),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
