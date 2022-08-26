import 'package:shopapp/models/shop_app/change_favorites_model.dart';
import 'package:shopapp/models/shop_app/login_model.dart';


abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeBottomNavState extends ShopStates{}

class ShopLoadingHomeDataState extends ShopStates{}

class ShopSuccessHomeDataState extends ShopStates{}

class ShopErrorHomeDataState extends ShopStates{}

class ShopSuccessCategoriesState extends ShopStates{}

class ShopErrorCategoriesState extends ShopStates{}

class ShopSuccessFavoritesState extends ShopStates{}

class ShopSuccessChangeFavoritesState extends ShopStates{
  final ChangeFavoritesModel? model;
  ShopSuccessChangeFavoritesState(this.model);
}//custom state for the change of the icon it should be separated from the success state because we figured out the there is another error could happen that the status could be false

class ShopErrorFavoritesState extends ShopStates{}

class ShopSuccessGetFavoritesState extends ShopStates{}

class ShopLoadingGetFavoritesState extends ShopStates{}//this is made to get the favorites again

class ShopErrorGetFavoritesState extends ShopStates{}

class ShopSuccessUserDataState extends ShopStates{
  final ShopLoginModel loginModel;
  ShopSuccessUserDataState(this.loginModel);

}

class ShopLoadingUserDataState extends ShopStates{}

class ShopErrorUserDataState extends ShopStates{}

class ShopSuccessUpdateUserState extends ShopStates{
  final ShopLoginModel loginModel;
  ShopSuccessUpdateUserState(this.loginModel);

}

class ShopLoadingUpdateUserState extends ShopStates{}

class ShopErrorUpdateUserState extends ShopStates{}
