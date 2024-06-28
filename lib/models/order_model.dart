// enum PaymentStatus {
//   paid,
//   notPaid,
// }
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
  String? createdAtDate;
  String? createdAtTime;
  //PaymentStatus? paymentStatus;

  Order({required this.label,required this.paidPrice});


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
    createdAtDate =data['createdAtDate'];
    createdAtTime =data['createdAtTime'];
    //paymentStatus = data['paymentStatus'] == 'paid' ? PaymentStatus.paid : PaymentStatus.notPaid;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "label": label,
      "totalPrice": totalPrice,
      "paidPrice": paidPrice,
      "discount": discount,
      "clientId": clientId,
      'createdAtDate':createdAtDate,
      'createdAtTime':createdAtTime,
     // 'paymentStatus': paymentStatus == PaymentStatus.paid ? 'paid' : 'notPaid',
    };
  }
}