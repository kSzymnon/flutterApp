import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SaveNewItem extends StatelessWidget {
  SaveNewItem({super.key, required this.passedId, required this.listName});

  DatabaseReference databaseReference = FirebaseDatabase.instance.ref('users');
  final TextEditingController _nameControl = TextEditingController();
  final TextEditingController _amountControl = TextEditingController();
  final String passedId;
  final String listName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dodaj nowy element'),
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
                databaseReference.child(passedId).child(listName)
                    .child(_nameControl.text)
                    .set({
                  'amount': _amountControl.text,
                  'collected': false
                });
                Navigator.pop(context, {
                  'name': _nameControl.text,
                  'amount': _amountControl.text,
                  'collected': false
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
