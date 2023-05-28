import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:lista_zakupowa/main.dart';
import 'package:lista_zakupowa/models/object_grocery_list.dart';
import 'package:lista_zakupowa/models/object_item_list.dart';
import 'package:lista_zakupowa/widget/grocery_list.dart';
import 'package:mockito/mockito.dart';


class MockDatabaseReference extends Mock implements DatabaseReference {}


void main() async{


  // Tests for gorcery_list.dart
  testWidgets('GroceryList displays a list of grocery items', (WidgetTester tester) async {

    final groceryList = [
      ObjectGroceryList('Item 1', []),
      ObjectGroceryList('Item 2', []),
    ];

    await tester.pumpWidget(MaterialApp(
      home: GroceryList(groceryList, passedId: 'test_id'),
    ));


    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item 2'), findsOneWidget);
  });

  testWidgets('GroceryList displays an empty list when there are no grocery items', (WidgetTester tester) async {

    final groceryList = <ObjectGroceryList>[];

    await tester.pumpWidget(MaterialApp(
      home: GroceryList(groceryList, passedId: 'test_id'),
    ));

    expect(find.byType(ListTile), findsNothing);
  });


  // Test for object_item_list.dart
  test('ObjectItemList test', () {
    final item = ObjectItemList('apple', 2, false);

    expect(item.getItem(), 'apple');
    expect(item.getAmount(), 2);
    expect(item.isCollected(), false);

    item.setAmount(3);
    item.setCollected(true);

    expect(item.getAmount(), 3);
    expect(item.isCollected(), true);
  });


  // Test for object_grocery_list.dart
  test('ObjectGroceryList test', () {
    final groceryList = [
      ObjectItemList('apple', 2, false),
      ObjectItemList('banana', 3, true),
    ];
    final list = ObjectGroceryList('Test List', groceryList);

    expect(list.title, 'Test List');
    expect(list.createTime, DateFormat('EEE d MMM').format(DateTime.now()));
    expect(list.totalAmount, 0);
    expect(list.groceryList.length, 2);
  });


  // Test for main.dart
  test('getDeviceId returns a string', () async {
    final String deviceId = await MyApp.getDeviceId();
    expect(deviceId, isA<String>());
  });



}




