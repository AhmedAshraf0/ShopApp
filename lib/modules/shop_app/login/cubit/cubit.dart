import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/models/shop_app/login_model.dart';
import 'package:shopapp/modules/shop_app/login/cubit/cubit.dart';
import 'package:shopapp/modules/shop_app/login/cubit/states.dart';
import 'package:shopapp/shared/network/end_points.dart';
import 'package:shopapp/shared/network/remote/dio_helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates>{
  late ShopLoginModel loginModel;

  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);
  void userLogin({required String email, required String password}){
    emit(ShopLoginLoadingState());
    DioHelper.postData(url: LOGIN, data: {
      'email':email,
      'password':password,
    }).then((value) {
      loginModel = ShopLoginModel.fromJson(value.data);
      emit(ShopLoginSucessState(loginModel));
    }).catchError((error){
      emit(ShopLoginErrorState(error.toString()));
      debugPrint(error.toString());
    });
  }

  IconData suffIcon = Icons.visibility_off_outlined;
  bool isnotVisible = true;
  void changeVisibility(){
    isnotVisible = !isnotVisible;
    if(isnotVisible){
      suffIcon = Icons.visibility_off_outlined;
    }else{
      suffIcon = Icons.visibility_outlined;
    }
    emit(ShopLoginPasswordVisibilityState());
  }
}