import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/layout/cubit/cubit.dart';
import 'package:shopapp/models/shop_app/search_model.dart';
import 'package:shopapp/modules/shop_app/search/cubit/cubit.dart';
import 'package:shopapp/modules/shop_app/search/cubit/states.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:shopapp/shared/styles/color.dart';

class SearchScreen extends StatelessWidget {
  var _formKey = GlobalKey<FormState>();
  var seachController = TextEditingController();

  SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: seachController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'You must Enter any Text to search!';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        SearchCubit.get(context).search(value);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        label: const Text('Search'),
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    if (state is SearchLoadingState) LinearProgressIndicator(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    if (state is SearchSuccessState)
                      Expanded(
                        child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => buildSearchItem(
                                SearchCubit.get(context).model!,
                                context,
                                index),
                            separatorBuilder: (context, index) => MyDivider(),
                            itemCount: SearchCubit.get(context)
                                .model!
                                .data!
                                .data!
                                .length),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSearchItem(SearchModel model, context , idx , {bool isOldPrice = false}) =>
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
                    image: NetworkImage('${model.data!.data![idx].image}'),
                    width: 120.0,
                    height: 120.0,
                  ),
                  if (model.data!.data![idx].discount != 0  && isOldPrice)
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
                      '${model.data!.data![idx].name}' + '\n',
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
                        Text(model.data!.data![idx].price.round().toString(),
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: defaultColor,
                            )),
                        const SizedBox(
                          width: 5.0,
                        ),
                        if (model.data!.data![idx].discount != 0  && isOldPrice)
                          Text(model.data!.data![idx].oldPrice.round().toString(),
                              style: const TextStyle(
                                fontSize: 11.0,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              )),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            ShopCubit.get(context).changeFavorites(model.data!.data![idx].id);
                          },
                          icon: CircleAvatar(
                            radius: 15.0,
                            backgroundColor: (ShopCubit.get(context).favorites[model.data!.data![idx].id] == true) ? defaultColor : Colors.grey,
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
