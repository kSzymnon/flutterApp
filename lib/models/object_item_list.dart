//interface produktu
class ObjectItemList {
  late int amount;
  late String item;
  late bool collected;

  ObjectItemList(this.item, this.amount,this.collected);

  getItem() {
    return item;
  }

  getAmount() {
    return amount;
  }

  isCollected() {
    return collected;
  }

  setAmount(am) {
    amount = am;
  }

  setCollected(check) {
    collected = check;
  }
}
