class ExchangeRate {
  int? id;
  String? currencyFrom;
  String? currencyTo;
  double? rate;

  ExchangeRate.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    currencyFrom = data['currencyFrom'];
    currencyTo = data['currencyTo'];
    rate = data['rate'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'currencyFrom': currencyFrom,
      'currencyTo': currencyTo,
      'rate': rate,
    };
  }
}
