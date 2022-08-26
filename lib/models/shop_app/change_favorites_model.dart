class ChangeFavoritesModel {
  bool status;
  String message;

  ChangeFavoritesModel.fromJson({required Map<String, dynamic> json})
      : status = json['status'],
        message = json['message'];
}
