import 'package:flutter/material.dart';
import 'package:lista_zakupowa/models/object_grocery_list.dart';
import 'package:lista_zakupowa/widget/single_grocery_list.dart';

class GroceryList extends StatefulWidget {
  GroceryList(this._groceryList, {super.key, required this.passedId});

  List<ObjectGroceryList> _groceryList = <ObjectGroceryList>[];
  final String passedId;

  @override
  State<GroceryList> createState() => _GroceryListState(id: passedId);
}

class _GroceryListState extends State<GroceryList> {
  _GroceryListState({required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  Widget _buildRow(ObjectGroceryList groceryList) {
    return Card(
      elevation: 8,
      child: ListTile(
        title: Text(groceryList.title),
        subtitle: Text(groceryList.createTime.toString()),
        trailing: Text("${groceryList.totalAmount} zł"),
        onTap: () {
          _chanceToGroceryList(groceryList);
        },
      ),
    );
  }

  void _chanceToGroceryList(ObjectGroceryList groceryList) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return SingleGroceryList(groceryList.groceryList, groceryList.title, passedId: id);
    }));
  }
}
