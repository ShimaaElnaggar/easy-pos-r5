class ClientData{
  int ? id;
  String ? name;
  String ? phone;
  String ? address;

  ClientData.fromJson(Map<String ,dynamic> data){
    id = data["id"];
    name = data["name"];
    phone = data["phone"];
    address = data["address"];

  }

  ClientData({required this.name});

  Map<String,dynamic> toJson(){
    return{
      "id" : id,
      "name" : name,
      "phone" : phone,
      "address" :address,
    };
  }
}