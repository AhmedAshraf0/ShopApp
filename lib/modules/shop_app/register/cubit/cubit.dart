import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/models/shop_app/login_model.dart';
import 'package:shopapp/modules/shop_app/login/cubit/cubit.dart';
import 'package:shopapp/modules/shop_app/register/cubit/states.dart';
import 'package:shopapp/shared/network/end_points.dart';
import 'package:shopapp/shared/network/remote/dio_helper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates>{
  late ShopLoginModel loginModel;

  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);
  void userRegister({required String email, required String password , required String name , required String phone}){
    emit(ShopRegisterLoadingState());
    DioHelper.postData(url: REGISTER, data: {
      'name':name,
      'email':email,
      'password':password,
      'phone':phone,
    }).then((value) {
      loginModel = ShopLoginModel.fromJson(value.data);
      emit(ShopRegisterSucessState(loginModel));
    }).catchError((error){
      emit(ShopRegisterErrorState(error.toString()));
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
    emit(ShopRegisterPasswordVisibilityInRegState());
  }
}