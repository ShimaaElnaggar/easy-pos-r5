class Product {
  int? id;
  String? name;
  String? description;
  double? price;
  int? stock;
  String? image;
  bool? isAvailable;
  int? categoryId;
  String? categoryName;
  String? categoryDesc;

  Product.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    name = data["name"];
    description = data["description"];
    price = data["price"];
    stock = data["stock"];
    image = data["image"];
    isAvailable = data["isAvailable"];
    categoryId = data["categoryId"];
    categoryName = data["categoryName"];
    categoryDesc = data["categoryDesc"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "stock": stock,
      "image": image,
      "isAvailable": isAvailable,
      "categoryId": categoryId,
    };
  }
}
