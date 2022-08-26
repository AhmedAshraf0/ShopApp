import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopapp/layout/cubit/cubit.dart';
import 'package:shopapp/layout/shop_app/shop_layout.dart';
import 'package:shopapp/modules/shop_app/login/cubit/cubit.dart';
import 'package:shopapp/modules/shop_app/login/cubit/states.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:shopapp/modules/shop_app/register/shop_register_screen.dart';
import 'package:shopapp/shared/components/constants.dart';
import 'package:shopapp/shared/network/local/cache_helper.dart';
import 'package:shopapp/shared/styles/color.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = false;
  final _formkey = GlobalKey<FormState>();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopLoginCubit(),
      child: BlocProvider(
        create: (context) => ShopLoginCubit(),
        child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
          listener: (context, state) {
            if (state is ShopLoginSucessState) {
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
                            'LOGIN',
                            style:
                                Theme.of(context).textTheme.headline4!.copyWith(
                                      color: Colors.black,
                                    ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            'Login now to browse our hot offers',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Colors.grey,
                                    ),
                          ),
                          const SizedBox(
                            height: 30.0,
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
                                  ShopLoginCubit.get(context).isnotVisible,
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Password is too short';
                              },
                              onFieldSubmitted: (value) {
                                if (_formkey.currentState!.validate()) {
                                  ShopLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                        ShopLoginCubit.get(context).suffIcon),
                                    onPressed: () {
                                      debugPrint("test1");
                                      ShopLoginCubit.get(context)
                                          .changeVisibility();
                                    },
                                  ),
                                  prefixIcon: Icon(Icons.lock))),
                          const SizedBox(
                            height: 30.0,
                          ),
                          ConditionalBuilder(
                            condition: state is! ShopLoginLoadingState,
                            builder: (BuildContext context) => defaultButton(
                                label1: 'LOGIN',
                                color: Colors.lightBlueAccent,
                                color2: Colors.white,
                                f1: () {
                                  if (_formkey.currentState!.validate()) {
                                    ShopLoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passwordController.text);
                                  }
                                }),
                            fallback: (context) => const Center(
                                child: CircularProgressIndicator()),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              defaultTextButton(
                                  text: 'Register',
                                  size: 18.0,
                                  color: Colors.blue,
                                  f1: () {
                                    navigateTo(context, ShopRegisterScreen());
                                  }),
                            ],
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
      ),
    );
  }
}
