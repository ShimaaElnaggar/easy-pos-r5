class Order {
  int? id;
  String? label;
  double? totalPrice;
  double? paidPrice;
  double? discount;
  int? clientId;
  String? clientName;
  String? clientPhone;
  String? clientAddress;

  Order({required this.label});


  Order.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    label = data["label"];
    totalPrice = data["totalPrice"];
    paidPrice = data["paidPrice"];
    discount = data["discount"];
    clientId = data["clientId"];
    clientName = data["clientName"];
    clientPhone = data["clientPhone"];
    clientAddress = data["clientAddress"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "label": label,
      "totalPrice": totalPrice,
      "paidPrice": paidPrice,
      "discount": discount,
      "clientId": clientId,
    };
  }
}