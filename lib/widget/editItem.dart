import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


//widok ekranu w którym edytuje się produkt
class EditItem extends StatelessWidget {
  EditItem({super.key, required this.passedId, required this.listName, required this.itemName, required this.amount, required this.collected});
//referencja bazy danych
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref('users');
  //kontrolka do wpisywania nazwy produktu
  final TextEditingController _nameControl = TextEditingController();
  //kontrolka do wpisywania ilości produktu
  final TextEditingController _amountControl = TextEditingController();
  //nazwa produktu
  final String itemName;
  //id urządzenia
  final String passedId;
  //nazwa listy
  final String listName;
  //ilość produktu
  final int amount;
  //czy produkt jest zebrany
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
                //przesłanie produktu do bazy danych
                databaseReference.child(passedId).child(listName).child(itemName).remove();
                databaseReference.child(passedId).child(listName).child(_nameControl.text).set({
                  'amount': _amountControl.text,
                  'collected': collected
                });
                //przesłanie produktu do innego widoku w którym doda się go do listy
                Navigator.pop(context, {
                  'name': _nameControl.text,
                  'amount': _amountControl.text,
                  'collected': collected
                });
                //czyszczenie inputów
                _amountControl.clear();
                _nameControl.clear();
              },
              child: const Text('Zapisz'),
            ),
          ],
        ));
  }

}