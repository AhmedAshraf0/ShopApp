import 'package:shopapp/models/shop_app/login_model.dart';

abstract class ShopRegisterStates{}

class ShopRegisterInitialState extends ShopRegisterStates{}

class ShopRegisterLoadingState extends ShopRegisterStates{}

class ShopRegisterSucessState extends ShopRegisterStates{
  final ShopLoginModel loginModel;
  ShopRegisterSucessState(this.loginModel);
}

class ShopRegisterPasswordVisibilityInRegState extends ShopRegisterStates{}

class ShopRegisterErrorState extends ShopRegisterStates{
  final String error;
  ShopRegisterErrorState(this.error);
}
