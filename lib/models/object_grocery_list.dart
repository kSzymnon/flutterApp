import 'object_item_list.dart';
import 'package:intl/intl.dart';

class ObjectGroceryList {
  late final String title;
  late final String createTime;
  late final double totalAmount;
  final List<ObjectItemList> groceryList;

  ObjectGroceryList(this.title, this.groceryList) {
    createTime = DateFormat('EEE d MMM').format(DateTime.now());
    totalAmount = 0;
  }

  // double _countTheCost() {
  //   double cost = 0.0;
  //   for (var item in groceryList) {
  //     cost += item.getCost();
  //   }
  //   return cost;
  // }
}
