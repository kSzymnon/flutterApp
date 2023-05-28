import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EditItem extends StatelessWidget {
  EditItem({super.key, required this.passedId, required this.listName, required this.itemName, required this.amount, required this.collected});

  DatabaseReference databaseReference = FirebaseDatabase.instance.ref('users');
  final String itemName;
  final TextEditingController _nameControl = TextEditingController();
  final TextEditingController _amountControl = TextEditingController();
  final String passedId;
  final String listName;
  final int amount;
  final bool collected;
  @override
  Widget build(BuildContext context) {
    _nameControl.text = itemName;
    _amountControl.text = amount.toString();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edytuj element'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 16),
                child: TextField(
                  controller: _nameControl,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.title),
                    hintText: 'Nazwa',
                    labelText: 'Podaj nazwę przedmiotu',
                  ),
                )),
            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 16),
                child: TextField(
                  controller: _amountControl,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.title),
                    hintText: 'Ilość',
                    labelText: 'Podaj ilość',
                  ),
                )),
            ElevatedButton(
              onPressed: () {
                databaseReference.child(passedId).child(listName).child(itemName).remove();
                databaseReference.child(passedId).child(listName).child(_nameControl.text).set({
                  'amount': _amountControl.text,
                  'collected': collected
                });
                Navigator.pop(context, {
                  'name': _nameControl.text,
                  'amount': _amountControl.text,
                  'collected': collected
                });
                _amountControl.clear();
                _nameControl.clear();

              },
              child: const Text('Zapisz'),
            ),
          ],
        ));
  }

}