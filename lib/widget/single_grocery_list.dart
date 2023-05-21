import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lista_zakupowa/models/object_item_list.dart';
import 'package:lista_zakupowa/widget/save_new_item.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/object_grocery_list.dart';

class SingleGroceryList extends StatefulWidget {
  SingleGroceryList(this._groceryList, this.title, {super.key, required this.passedId});
  final String passedId;
  String title = "";
  List<dynamic> _groceryList = <ObjectItemList>[];
  @override
  State<StatefulWidget> createState() => _SingleGroceryList(id: passedId);
}

class _SingleGroceryList extends State<SingleGroceryList> {
  final String id;
  final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  _SingleGroceryList({required this.id});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista zakupów: ${widget.title}'),
          actions: [
            IconButton(onPressed: ()=>_saveNewItem(id, widget.title), icon: const Icon(Icons.add))
          ],
        ),
        body: Scaffold(
          body: Card(
            elevation: 18,
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: widget._groceryList.length,
              itemBuilder: (context, index) {
                return _buildRow(widget._groceryList[index]);
              },
            ),
          ),
        ));
  }

  Widget _buildRow(ObjectItemList groceryList) {
    return ListTile(
      title: Text(groceryList.getItem()),
      subtitle: Text(groceryList.getAmount().toString()),
      trailing: Icon(
        groceryList.isCollected() ? Icons.check : Icons.check_box_outline_blank,
        color: groceryList.isCollected() ? Colors.green : null,
      ),
      onTap: () {
        setState(() {
          if (groceryList.isCollected()) {
            setCollected(id, widget.title, groceryList.getItem(), false, groceryList.getAmount().toString());
            groceryList.setCollected(false);
          } else {
            setCollected(id, widget.title, groceryList.getItem(), true, groceryList.getAmount().toString());
            groceryList.setCollected(true);
          }
        });
      },
    );
  }

  void _saveNewItem(passedId, listName) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return SaveNewItem(passedId: passedId, listName: listName);
    })).then((item) => {
      widget._groceryList.add(ObjectItemList(item['name'], int.parse(item['amount']),item['collected']))
    });
    // widget._groceryList.add(ObjectItemList(value.toString()));
  }

  void setCollected(passedId, listName, item, isCollected, amount) {
    databaseReference.child('users').child(passedId).child(listName).child(item)
        .set({
      'amount': amount,
      'collected': isCollected
    });
  }
}
