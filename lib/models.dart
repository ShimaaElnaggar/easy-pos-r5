class CategoryData{
  int? id;
  String? categoryName;
  String? description;

  CategoryData.fromJson( Map<String,dynamic> data){
    id = data["id"];
    categoryName = data["categoryName"];
    description = data["description"];
  }

  Map<String,dynamic> toJson (){
    return{"id" : id , "categoryName" : categoryName , "description" : description};
}
}