class UserData {//just to initialize data
  int? id, points, credits;
  String? name, email, phone, image, token;

  // UserData({
  //   required this.id,
  //   required this.name,
  //   required this.email,
  //   required this.phone,
  //   required this.image,
  //   required this.points,
  //   required this.credits,
  //   required this.token,
  // });

  UserData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        phone = json['phone'],
        image = json['image'],
        points = json['points'],
        credits = json['credits'],
        token = json['token'];

  UserData.notFound()
      : id = null,
        name = null,
        email = null,
        phone = null,
        image = null,
        points = null,
        credits = null,
        token = null;
}

class ShopLoginModel {//here is the start the big map
  bool status;
  String message;
  UserData data;

  ShopLoginModel.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        message = json['message'],
        data = (json['data'] != null) ? (UserData.fromJson(json['data'])) : (UserData.notFound());
}


