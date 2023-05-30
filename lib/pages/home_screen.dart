import 'package:flutter/material.dart';
import 'package:lista_zakupowa/widget/grocery_list.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/object_grocery_list.dart';
import '../models/object_item_list.dart';
import '../widget/save_new_grocery_list.dart';


//ekran główny
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.deviceId});
  //id urządzenia
  final String deviceId;

  @override
  State<HomeScreen> createState() => _HomeScreenState(deviceId: deviceId);
}

class _HomeScreenState extends State<HomeScreen>{
  //lista produktow
  final List<ObjectGroceryList> groceryList = <ObjectGroceryList>[];
  //referencja bazy danych
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  //id urzadzenia
  final String deviceId;
  //produkty
  List<ObjectItemList> listOfItem = <ObjectItemList>[];

  _HomeScreenState({required this.deviceId});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    readData();
  }


  //funkcja ustawiająca referencje do bazy danych
  readData() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref('users/$deviceId');
    DatabaseEvent data = await databaseReference.once();
    if (data.snapshot.value != null) {
      makeLists(data.snapshot.value);
    }
  }

  //funkcja tworząca listy produktow pobranych z bazy danych
  makeLists(data) {
    groceryList.clear();
    data.forEach((name, data) {
      data.forEach((name, data){
        if (data==true) {
          return;
        }
        else {
          listOfItem.add(ObjectItemList(name, int.parse(data['amount']),data['collected']));
        }
      });
      setState(() {
        groceryList.add(ObjectGroceryList(name, listOfItem));
      });

      listOfItem = <ObjectItemList>[];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text("Twoje listy zakupowe"),
        actions: [
          IconButton(
              onPressed: _saveNewGroceryList, icon: const Icon(Icons.add))
        ],

      ),
      body:
      GroceryList(groceryList, passedId: deviceId),
    );
  }
  //przeniesienie do widoku dodawania nowej listy produktow
  void _saveNewGroceryList() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Utwórz nową listę'),
        ),
        body: SaveNewGroceryList(passedId: deviceId),
      );
    })).then((value) {
      readData();
    });
  }
}
