class CategoryData {
  int? id;
  String? name;
  String? description;

  CategoryData({this.name, this.description, this.id});
  CategoryData.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    name = data["name"];
    description = data["description"];
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "description": description};
  }
}
