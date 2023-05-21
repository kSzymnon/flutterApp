import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class SaveNewGroceryList extends StatelessWidget {
  SaveNewGroceryList({super.key, required this.passedId});
  final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  final String passedId;
  final TextEditingController _textEditingController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                icon: Icon(Icons.title),
                hintText: 'Tytuł',
                labelText: 'Podaj tytuł swojej listy',
              ),
            )),
        ElevatedButton(
          onPressed: () {
            String listName = _textEditingController.text;
            databaseReference.child('users').child(passedId).child(listName)
                .set({
              'isEmpty': true
            });
            _textEditingController.clear();
          },
          child: const Text('Dodaj listę'),
        ),
      ],

    );
  }
}
