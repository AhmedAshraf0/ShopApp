import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/layout/cubit/cubit.dart';
import 'package:shopapp/layout/cubit/states.dart';
import 'package:shopapp/models/shop_app/categories_model.dart';
import 'package:shopapp/models/shop_app/home_model.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:shopapp/shared/styles/color.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {
          if (state is ShopSuccessChangeFavoritesState) {
            if (!state.model!.status) {
              mainToast(
                state: ToastStates.ERROR,
                message: state.model!.message,
              );
            }
          }
        },
        builder: (context, state) {
          return ConditionalBuilder(
            condition: ShopCubit.get(context).homeModel != null &&
                ShopCubit.categoriesStatus != null,
            builder: (BuildContext context) => productsBuilder(context),
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  Widget productsBuilder(BuildContext context) {
    //i didn't add homedata as parameter because it's not working because the null problem so i made it static so i could access it after creating
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: HomeData.banners
                .map(
                  (e) => Image(
                    image: NetworkImage(e.image),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
                .toList(),
            options: CarouselOptions(
              height: 250.0,
              initialPage: 0,
              viewportFraction: 1.0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 100.0,
                  child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => buildCategoryItem(
                          ShopCubit.categoriesStatus!.data.data[index]),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10.0),
                      itemCount: ShopCubit.categoriesStatus!.data.data.length),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                const Text(
                  'New Products',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 1.0,
            childAspectRatio: 1 / 1.72,
            children: List.generate(
              HomeData.products.length,
              (index) => Container(
                child: buildGridProduct(HomeData.products[index], context),
                color: Colors.grey[300],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGridProduct(ProductModel productModel, context) {
    bool? value = ShopCubit.get(context).favorites[productModel.id];
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage(productModel.image),
                width: double.infinity,
                height: 200.0,
              ),
              if (productModel.discount != 0)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  alignment: Alignment.center,
                  color: Colors.red,
                  width: 60.0,
                  child: const Text(
                    'Discount',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productModel.name + '\n',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.0,
                    height: 1.3,
                  ),
                ),
                Row(
                  children: [
                    Text('${productModel.price.round()}',
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: defaultColor,
                        )),
                    const SizedBox(
                      width: 5.0,
                    ),
                    if (productModel.discount != 0)
                      Text('${productModel.oldPrice.round()}',
                          style: const TextStyle(
                            fontSize: 11.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          )),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        ShopCubit.get(context).changeFavorites(productModel.id);
                      },
                      icon: CircleAvatar(
                        radius: 15.0,
                        backgroundColor:
                            (value == true) ? defaultColor : Colors.grey,
                        child: Icon(
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
    );
  }

  Widget buildCategoryItem(DataModel model) => Container(
        width: 100.0,
        height: 100.0,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Image(
              image: NetworkImage(model.image),
              width: 100.0,
              height: 100.0,
            ),
            Container(
                width: double.infinity,
                color: Colors.black.withOpacity(0.8),
                child: Text(model.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                    ))),
          ],
        ),
      );
}
