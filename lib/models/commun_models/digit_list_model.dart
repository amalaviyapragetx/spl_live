class DigitListModelOffline {
  String? value;
  bool? isSelected;
  int? coins;

  DigitListModelOffline({
    this.value,
    this.isSelected,
    this.coins,
  });

  DigitListModelOffline.fromJson(json) {
    value = json;
    isSelected = false;
    coins = 0;
  }
}
