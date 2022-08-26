import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/layout/shop_app/shop_layout.dart';
import 'package:shopapp/modules/shop_app/register/cubit/cubit.dart';
import 'package:shopapp/modules/shop_app/register/cubit/states.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:shopapp/shared/components/constants.dart';
import 'package:shopapp/shared/network/local/cache_helper.dart';

class ShopRegisterScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  ShopRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state) {//to move on after press register
          if (state is ShopRegisterSucessState) {
            if (state.loginModel.status) {
              mainToast(
                  message: state.loginModel.message,
                  state: ToastStates.SUCCESS);
              CacheHelper.saveData(
                key: 'token',
                value: state.loginModel.data.token,
              ).then((value) {
                token = state.loginModel.data.token!;//that's done to avoid error after logout and login again to found token to use and to avoid using the old token so i initialize it here when i will need it after this screen, prepare it
                navigateAndFinish(context, ShopLayout());
              });
              // debugPrint(state.loginModel.data.token);
            } else {
              mainToast(
                  message: state.loginModel.message,
                  state: ToastStates.ERROR);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER',
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          'REGISTER now to browse our hot offers',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'You have to enter a name';
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'User Name',
                              prefixIcon: Icon(Icons.person)),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'You have to enter an email';
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email Address',
                              prefixIcon: Icon(Icons.email_outlined)),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText:
                                ShopRegisterCubit.get(context).isnotVisible,
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Password is too short';
                            },
                            onFieldSubmitted: (value) {},
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                      ShopRegisterCubit.get(context).suffIcon),
                                  onPressed: () {
                                    debugPrint("test1");
                                    ShopRegisterCubit.get(context)
                                        .changeVisibility();
                                  },
                                ),
                                prefixIcon: Icon(Icons.lock))),
                        const SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'you have to enter a phone';
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Phone',
                                prefixIcon: Icon(Icons.phone))),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: (state is! ShopRegisterLoadingState),
                          builder: (BuildContext context) =>
                              defaultButton(
                                  label1: 'REGISTER',
                                  color: Colors.lightBlueAccent,
                                  color2: Colors.white,
                                  f1: () {
                                    if (_formkey.currentState!.validate()) {
                                      ShopRegisterCubit.get(context).userRegister(
                                        name: nameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        phone: phoneController.text,
                                      );
                                    }
                                  }),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
