import 'package:exshange/providers/items.dart';
import 'package:exshange/screens/item_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({super.key});
  final routeName = '/itemdetail';

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ItemArgs;
    final items = Provider.of<Items>(context, listen: false).items;
    final item = items.firstWhere((element) => element.id == args.itemId);

    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียด'),
      ),
      body: Hero(
        tag: 'heroItem${args.itemIndex}',
        child: Image.network(
          item.imagesUrl[0],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
