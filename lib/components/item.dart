import 'package:flutter/material.dart';
import 'package:wareflow/models/item_model.dart';

class Items extends StatefulWidget {
  final ItemModel item;
  const Items({super.key, required this.item});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: ListTile(
          leading: Image(
            image: AssetImage(widget.item.img),
            width: 40,
            height: 40,
            fit: BoxFit.fill,
          ),
          title: Text(widget.item.name),
          subtitle: Text(widget.item.price.toString()),
          trailing: Text(widget.item.quantity.toString()),
        ),
      ),
    );
  }
}
