import 'package:shopapp/models/shop_app/login_model.dart';

abstract class ShopLoginStates{}

class ShopLoginInitialState extends ShopLoginStates{}

class ShopLoginLoadingState extends ShopLoginStates{}

class ShopLoginSucessState extends ShopLoginStates{
  final ShopLoginModel loginModel;
  ShopLoginSucessState(this.loginModel);
}

class ShopLoginPasswordVisibilityState extends ShopLoginStates{}

class ShopLoginErrorState extends ShopLoginStates{
  final String error;
  ShopLoginErrorState(this.error);
}
