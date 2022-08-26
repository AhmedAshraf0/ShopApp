class CategoriesStatus {//first object
  bool status;
  CategoriesDataModel data;

  // CategoriesStatus({required this.status , required this.data}); we will not use it
  CategoriesStatus.fromJson({required Map<String, dynamic> json})
      : status = json['status'],
        data = CategoriesDataModel.fromJson(json: json['data']);
}

class CategoriesDataModel {//first data in the first object
  late int currentPage; //after it there is another data so create model for it
  List<DataModel> data = [];

  CategoriesDataModel.fromJson({required Map<String, dynamic> json}){
    currentPage = json['current_page'];
    json['data'].forEach((element){
      data.add(DataModel.fromJson(json: element));
    });
  }

}

class DataModel {
  int id;
  String name, image;

  DataModel.fromJson({required Map<String, dynamic> json})
      : id = json['id'],
        name = json['name'],
        image = json['image'];
}
