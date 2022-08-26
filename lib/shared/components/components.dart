import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopapp/layout/cubit/cubit.dart';
import 'package:shopapp/shared/styles/color.dart';

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => widget),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false,
    );

Widget defaultButton({required String label1, required Color color , required Color color2 , required VoidCallback f1}) =>
    Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: MaterialButton(
          child: Text(
            label1,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color2,
            ),
          ),
          color: color,
          minWidth: double.infinity,
          height: 50.0,
          onPressed: f1),
    );

Widget defaultTextButton({required String text , required double size , required Color color , required VoidCallback f1}) => TextButton(
  onPressed: f1,
  child: Text(
    text,
    style: TextStyle(
      fontSize: size,
      color: color,
    ),
  ),
);

void mainToast({required String message , required ToastStates state}){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0);
}

enum ToastStates {SUCCESS  , ERROR , WARNING}

Color chooseToastColor(ToastStates state){
  if(state == ToastStates.SUCCESS)
    return Colors.green;
  else if(state == ToastStates.ERROR)
    return Colors.red;
  //the last condition without if 2 birds with one stone error of the return and the last condition
  return Colors.amber;
}

Widget MyDivider() => Padding(
  padding: const EdgeInsets.all(8.0),
  child:   Container(
    width: double.infinity,
    height: 1,
    color: Colors.grey,
  ),
);

Widget buildListProduct(model, context , {bool isOldPrice = true}) =>
    Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 120.0,
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage('${model.product!.image}'),
                  width: 120.0,
                  height: 120.0,
                ),
                if (model.product!.discount != 0 && isOldPrice)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ),
                    alignment: Alignment.center,
                    color: Colors.red,
                    width: 60.0,
                    height: 20.0,
                    child: const Text(
                      'Discount',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.product!.name}' + '\n',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(model.product!.price.round().toString(),
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: defaultColor,
                          )),
                      const SizedBox(
                        width: 5.0,
                      ),
                      if (model.product!.discount != 0  && isOldPrice)
                        Text(model.product!.oldPrice.round().toString(),
                            style: const TextStyle(
                              fontSize: 11.0,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            )),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopCubit.get(context).changeFavorites(model.product!.id);
                        },
                        icon: CircleAvatar(
                          radius: 15.0,
                          backgroundColor: (ShopCubit.get(context).favorites[model.product!.id] == true) ? defaultColor : Colors.grey,
                          child: const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );