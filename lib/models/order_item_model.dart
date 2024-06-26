import 'package:easy_pos_r5/models/product.dart';

class OrderItem {
  int? orderId;
  int? productId;
  int? productCount;
  Product? product;
  double? totalProductCount;
  double? totalProductPrice;

  OrderItem({
    this.orderId,
    this.productId,
    this.productCount,
    this.product,

  });

  OrderItem.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    productId = json['productId'];
    productCount = json['productCount'];
    product = Product.fromJson(json);
  }
}
