import 'package:flutter/material.dart';
import 'package:lista_zakupowa/models/object_item_list.dart';
import 'package:lista_zakupowa/widget/editItem.dart';
import 'package:lista_zakupowa/widget/save_new_item.dart';
import 'package:firebase_database/firebase_database.dart';

class SingleGroceryList extends StatefulWidget {
  SingleGroceryList(this._groceryList, this.title, {super.key, required this.passedId});
  //id urządzenia
  final String passedId;
  //nazwa listy
  String title = "";
  //produkty znajdujące się w liście
  List<dynamic> _groceryList = <ObjectItemList>[];
  @override
  State<StatefulWidget> createState() => _SingleGroceryList();
}

class _SingleGroceryList extends State<SingleGroceryList> {
  //referencja do bazy danych
  final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  _SingleGroceryList();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista zakupów: ${widget.title}'),
          actions: [
            IconButton(onPressed: ()=>_saveNewItem(widget.passedId, widget.title), icon: const Icon(Icons.add))
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            groceryList.isCollected() ? Icons.check : Icons.check_box_outline_blank,
            color: groceryList.isCollected() ? Colors.green : null,
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              _editItem(widget.passedId, widget.title, groceryList);
            },
            child: const Icon(
              Icons.border_color_outlined,
              color: Colors.orange,
            ),
          ),const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              deleteItem(groceryList);
            },
            child: const Icon(
              Icons.clear,
              color: Colors.red,
            ),
          ),
        ],
      ),
      onTap: () {
        setState(() {
          if (groceryList.isCollected()) {
            setCollected(widget.passedId, widget.title, groceryList.getItem(), false, groceryList.getAmount().toString());
            groceryList.setCollected(false);
          } else {
            setCollected(widget.passedId, widget.title, groceryList.getItem(), true, groceryList.getAmount().toString());
            groceryList.setCollected(true);
          }
        });
      },
    );
  }
//funkcja, odpowiadająca za przeniesienie do innego okna w którym dodaje się nowy produkt do listy
  void _saveNewItem(passedId, listName) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return SaveNewItem(passedId: passedId, listName: listName);
    })).then((item) => {
      widget._groceryList.add(ObjectItemList(item['name'], int.parse(item['amount']),item['collected']))
    });
  }
//funkcja, odpowiadająca za przeniesienie do innego okna w którym edytuje się produkt z listy
  void _editItem(passedId, listName, ObjectItemList groceryList) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return EditItem(passedId: passedId, listName: listName, itemName: groceryList.getItem(), amount: groceryList.getAmount(), collected: groceryList.isCollected());
    })).then((item) => {
      setState(() {
        widget._groceryList.remove(groceryList);
        widget._groceryList.add(ObjectItemList(item['name'], int.parse(item['amount']),item['collected']));
      })

    });
  }
//funkcja usuwająca produkt z listy
  void deleteItem(ObjectItemList groceryList) {
    databaseReference.child('users').child(widget.passedId).child(widget.title).child(groceryList.getItem()).remove();
    setState(() {
      widget._groceryList.remove(groceryList);
    });
  }
  //funkcja ustawiająca pozycję collected produktu
  void setCollected(passedId, listName, item, isCollected, amount) {
    databaseReference.child('users').child(passedId).child(listName).child(item)
        .set({
      'amount': amount,
      'collected': isCollected
    });
  }
}
