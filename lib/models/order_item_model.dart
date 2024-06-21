import 'package:easy_pos_r5/models/product.dart';

class OrderItem {
  int? orderId;
  int? productId;
  int? productCount;
  Product? product;
  bool? isPaid;

  OrderItem({
    this.orderId,
    this.productId,
    this.productCount,
    this.product,
    this.isPaid
  });

  OrderItem.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    productId = json['productId'];
    productCount = json['productCount'];
    product = Product.fromJson(json);
    isPaid = json['isPaid'];
  }
}
