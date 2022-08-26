import 'package:shopapp/layout/cubit/cubit.dart';
import 'package:shopapp/layout/cubit/states.dart';
import 'package:shopapp/modules/shop_app/login/shop_login_screen.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:shopapp/shared/network/local/cache_helper.dart';

void signOut(context){
  CacheHelper.clearData(key: 'token').then((value) {
    if (value) {

      ShopCubit.currentIndex = 0;
      navigateAndFinish(context, LoginScreen());
    }
  });
}

void printFullText(String text){
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

String token = '';

bool logOutButton = false;
