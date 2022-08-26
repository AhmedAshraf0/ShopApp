import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/layout/cubit/cubit.dart';
import 'package:shopapp/layout/cubit/states.dart';
import 'package:shopapp/models/shop_app/favorites_model.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:shopapp/shared/styles/color.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return ConditionalBuilder(
            condition: state is! ShopLoadingGetFavoritesState,
            builder: (BuildContext context) => ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => buildFavItem(
                    ShopCubit.get(context).favoritesModel!.data!.data![index],
                    context),
                separatorBuilder: (context, index) => MyDivider(),
                itemCount:
                    ShopCubit.get(context).favoritesModel!.data!.data!.length),
            fallback: (BuildContext context) => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget buildFavItem(FavoritesData model, context) =>
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
                  if (model.product!.discount != 0)
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
                        if (model.product!.discount != 0)
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
}
