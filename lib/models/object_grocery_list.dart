import 'object_item_list.dart';
import 'package:intl/intl.dart';

//interface listy produktow
class ObjectGroceryList {
  late final String title;
  late final String createTime;
  late final double totalAmount;
  final List<ObjectItemList> groceryList;

  ObjectGroceryList(this.title, this.groceryList) {
    createTime = DateFormat('EEE d MMM').format(DateTime.now());
    totalAmount = 0;
  }
}
