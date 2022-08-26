class HomeModel {
  bool status;
  HomeData? data;

  //HomeModel({required this.status, required this.data});

  HomeModel.fromJson({required Map<String, dynamic> json}) :
        status = json['status'],
        data = HomeData.fromJson(json: json['data']);

}

class HomeData {
  static List<BannerModel> banners = []; //because it will add on it
  static List<ProductModel> products = [];

  HomeData.fromJson({required Map<String, dynamic> json}){
    json['banners'].forEach((element) {
      banners.add(BannerModel.fromJson(json: element));//named constructor(which needs a specific map) will return object of bannermodel so it could be added
    });
    json['products'].forEach((element) {
      products.add(ProductModel.fromJson(json: element));
    });
  }

}

class BannerModel {
  int id;
  String image;

  BannerModel.fromJson({required Map<String, dynamic> json})
      :
        id = json['id'],
        image = json['image'];
}

class ProductModel {
  int id;
  dynamic price, oldPrice, discount;
  String image , name;
  bool inCart , inFavorites;

  ProductModel.fromJson({required Map<String, dynamic> json})
      :
        id = json['id'],
        price = json['price'],
        oldPrice = json['old_price'],
        discount = json['discount'],
        image = json['image'],
        name = json['name'],
        inCart = json['in_cart'],
        inFavorites = json['in_favorites'];
}