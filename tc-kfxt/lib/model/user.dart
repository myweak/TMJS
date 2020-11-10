class User {
  int id;
  String headimg;
  String phone;
  String name;
  int status;

  static User fromMap(Map<String, dynamic> map) {
    if(map == null) return null;
    User user = User();
    user.id = map["id"];
    user.headimg = map["headimg"];
    user.phone = map["phone"];
    user.name = map["name"];
    user.status = map["status"];
    return user;
  }

  Map tojson() => {
    "id": id,
    "headimg": headimg,
    "phone": phone,
    "name": name,
    "status": status,
  };
}