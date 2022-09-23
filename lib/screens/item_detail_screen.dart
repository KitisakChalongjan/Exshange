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
    final items = context.read<Items>().items;
    final item = items.firstWhere((element) => element.id == args.itemId);

    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียด'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Color.fromARGB(255, 57, 57, 57)),
              height: 400,
              width: double.infinity,
              child: Hero(
                tag: 'heroItem${args.index}',
                child: Image.network(
                  item.imagesUrl[0],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 45,
              child: Row(
                children: [
                  Flexible(
                    flex: 8,
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        boxShadow: [],
                      ),
                      child: Text(
                        item.name,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: item.itemType == 'แลกเปลื่ยน'
                            ? Theme.of(context).primaryColorLight
                            : Color(0XFF68EDD2),
                        boxShadow: [],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        item.itemType == 'แลกเปลื่ยน' ? 'แลก' : 'ให้',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              height: 300,
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              child: Column(
                children: [
                  Text(
                    item.detail,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    item.detail,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    item.detail,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        child: BottomAppBar(
          color: item.itemType == "แลกเปลื่ยน"
              ? Theme.of(context).primaryColor
              : Color(0XFF68EDD2),
          child: Container(
            height: 40,
            child: Text(
              item.itemType == "แลกเปลื่ยน" ? 'เสนอ' : 'ขอ',
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
