import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/layout/cubit/states.dart';
import 'package:shopapp/models/shop_app/categories_model.dart';
import 'package:shopapp/models/shop_app/change_favorites_model.dart';
import 'package:shopapp/models/shop_app/favorites_model.dart';
import 'package:shopapp/models/shop_app/home_model.dart';
import 'package:shopapp/models/shop_app/login_model.dart';
import 'package:shopapp/modules/shop_app/categories/categories.dart';
import 'package:shopapp/modules/shop_app/favourites/favourites_screen.dart';
import 'package:shopapp/modules/shop_app/products/products_screen.dart';
import 'package:shopapp/modules/shop_app/settings/setting.dart';
import 'package:shopapp/shared/components/constants.dart';
import 'package:shopapp/shared/network/end_points.dart';
import 'package:shopapp/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of<ShopCubit>(context);
  static int currentIndex = 0;
  List<Widget> bottomScreens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavouritesScreen(),
    SettingScreen(),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel =
      null; //must be inizialized because i need to access it before it's have any values so it can't be late

  Map<int?, bool> favorites = {};

  void loadFromScratch(){
    if(logOutButton){
      logOutButton = false;
      print('here');
      getHomeData();
    }
  }
  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(url: HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(json: value.data);
      // printFullText(homeModel.toString());
      // printFullText(homeModel!.data!.banners[0].image);
      // print(homeModel!.status);
      HomeData.products.forEach((element) {
        favorites.addAll({
          element.id: element.inFavorites,
        });
      });
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  static CategoriesStatus? categoriesStatus =
      null; //must be inizialized because i need to access it before it's have any values so it can't be late
  void getCategoryData() {
    DioHelper.getData(url: Get_Categories, token: token).then((value) {
      categoriesStatus = CategoriesStatus.fromJson(json: value.data);
      // printFullText(homeModel.toString());
      // printFullText(homeModel!.data!.banners[0].image);
      // print('here is category '+'${categoriesStatus!.status}');
      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel =
      null; //because it's must be initialized so to skip the error i do this, and of course it will have data after the func
  void changeFavorites(int? productId) {
    //we only needs the status and the message after posting not the data
    favorites[productId] = (favorites[productId] == true)
        ? false
        : true; // to toggle the icon color immediately
    emit(ShopSuccessChangeFavoritesState(changeFavoritesModel));
    DioHelper.postData(
      url: FAVORITES,
      data: {'product_id': productId},
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(json: value.data);
      print("From changeFavorites" + value.toString());

      if (!changeFavoritesModel!.status) {
        //that means that there is an error
        //if status from api is false so return the icon color to its initial color and show the use that there is a problem
        favorites[productId] = (favorites[productId] == true)
            ? false
            : true; //notice that the state is success because the error happened in successState
      } else {
        getFavorites(); //if it's true get the favs again & if the status is true
      }
      emit(ShopSuccessFavoritesState());
    }).catchError((error) {
      favorites[productId] = (favorites[productId] == true)
          ? false
          : true; //if status from api is false so return the icon color to its initial color and show the use that there is a problem
      print('IN FAVORITES' + error.toString());
      emit(ShopErrorFavoritesState());
    });
  }

  FavoritesModel? favoritesModel =
      null; //must be inizialized because i need to access it before it's have any values so it can't be late
  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(url: FAVORITES, token: token).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      printFullText(value.data.toString());
      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  ShopLoginModel? userModel =
      null; //must be inizialized because i need to access it before it's have any values so it can't be late
  void getUserData() {
    emit(ShopLoadingUserDataState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      print(userModel!.data.name);
      emit(ShopSuccessUserDataState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateUserState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name' : name,
        'email' : email,
        'phone' : phone,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);//modify on the same userModel
      print(userModel!.data.name);
      emit(ShopSuccessUpdateUserState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserState());
    });
  }
}
