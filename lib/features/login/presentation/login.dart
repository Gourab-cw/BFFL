import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';

import '../../../core/utility/firebase_service.dart';
import '../repository/authenticator.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  MainStore mainStore = Get.find<MainStore>();
  final loaderController = Get.find<AppLoaderController>();
  Authenticator user = Get.find<Authenticator>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late final EdgeInsets safePadding = MediaQuery.paddingOf(context);
  bool showPassword = false;
  bool isCreateAccount = false;
  bool showNow = false;

  double opacity = 0;
  double height = 10;

  late double sizeBoxHeight = MediaQuery.sizeOf(context).height * .5;

  void changeLoginMode() {
    setState(() {
      isCreateAccount = !isCreateAccount;
    });
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    Future(() {
      try {
        // loaderController.startLoading();
        // user.checkIfUserLogin().whenComplete(() {
        //   loaderController.stopLoading();
        // });
        Timer(const Duration(milliseconds: 400), () {
          setState(() {
            showNow = true;
          });
        });
        Timer(const Duration(milliseconds: 500), () {
          setState(() {
            height = MediaQuery.sizeOf(context).height * 0.7;
            sizeBoxHeight = 20;
          });
        });
        Timer(const Duration(milliseconds: 1300), () {
          setState(() {
            opacity = 1;
          });
        });
      } catch (e) {
        showAlert("$e", AlertType.error);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              AnimatedContainer(duration: const Duration(milliseconds: 700), curve: Curves.fastEaseInToSlowEaseOut, height: sizeBoxHeight),
              TextHelper(
                text: "Health & Wellness",
                fontsize: 25,
                fontweight: FontWeight.w600,
                color: Colors.blueGrey.shade700,
                textalign: TextAlign.center,
                padding: EdgeInsets.all(30),
              ),
              if (showNow)
                AnimatedOpacity(
                  opacity: opacity,
                  curve: Curves.easeInOutSine,
                  duration: const Duration(milliseconds: 800),
                  child: AnimatedContainer(
                    height: height,
                    width: 400,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastEaseInToSlowEaseOut,
                    child: ClipRect(
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.all(12),
                          padding: EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            // color: getMainStore().theme.value.HeadColor.withAlpha(20),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: getMainStore().theme.value.HeadColor.withAlpha(30)),
                            boxShadow: [BoxShadow(spreadRadius: 1, blurRadius: 8, color: Colors.grey.shade200)],
                          ),
                          child: Column(
                            spacing: 10,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextHelper(
                                text: isCreateAccount ? "Create an Account?" : "Login",
                                textalign: TextAlign.center,
                                color: Colors.blueGrey.shade600,
                                fontweight: FontWeight.w600,
                                fontsize: 21,
                              ),
                              Column(
                                spacing: 10,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isCreateAccount)
                                    Column(
                                      spacing: 6,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextHelper(text: "Name", fontweight: FontWeight.w600),
                                        TextBox(
                                          controller: nameController,
                                          leading: Icon(Icons.account_circle_rounded, size: 20, color: Colors.blueGrey.shade400),
                                          borderRadius: 30,
                                          backgroundColor: getMainStore().theme.value.BackgroundColor,
                                        ),
                                      ],
                                    ),
                                  Column(
                                    spacing: 6,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextHelper(text: "Email", fontweight: FontWeight.w600),
                                      TextBox(
                                        controller: emailController,
                                        leading: Icon(Icons.mail, size: 20, color: mainStore.theme.value.HeadColor.withAlpha(200)),
                                        borderRadius: 30,
                                        backgroundColor: mainStore.theme.value.BackgroundColor,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    spacing: 6,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextHelper(text: "Password", fontweight: FontWeight.w600),
                                      TextBox(
                                        controller: passwordController,
                                        leading: Icon(Icons.password, size: 20, color: mainStore.theme.value.HeadColor.withAlpha(200)),
                                        borderRadius: 30,
                                        obscureText: !showPassword,
                                        backgroundColor: mainStore.theme.value.BackgroundColor,
                                        trailing: ButtonHelperG(
                                          onTap: () {
                                            setState(() {
                                              showPassword = !showPassword;
                                            });
                                          },
                                          background: Colors.transparent,
                                          width: 25,
                                          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off_rounded, size: 18, color: Colors.blueGrey.shade400),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              ButtonHelperG(
                                onTap: () async {
                                  // ref.read(appLoaderProvider.notifier).startLoading();
                                  loaderController.startLoading();
                                  if (isCreateAccount) {
                                    try {
                                      await user.addUser(email: emailController.text, password: passwordController.text, name: nameController.text);
                                    } catch (e) {
                                      showAlert("$e", AlertType.error);
                                    } finally {
                                      loaderController.stopLoading();
                                      // ref.read(appLoaderProvider.notifier).stopLoading();
                                    }
                                  } else {
                                    try {
                                      bool redirect = await user.emailLogin(email: emailController.text.trim(), password: passwordController.text.trim());
                                      // if(redirect){
                                      //   Get.offAllNamed("/home");
                                      // }
                                    } catch (e) {
                                      showAlert("$e", AlertType.error);
                                    } finally {
                                      loaderController.stopLoading();
                                      // ref.read(appLoaderProvider.notifier).stopLoading();
                                    }
                                  }
                                },
                                width: MediaQuery.sizeOf(context).width * 0.8 > 300 ? 300 : MediaQuery.sizeOf(context).width * 0.8,
                                borderRadius: 20,
                                label: TextHelper(
                                  text: isCreateAccount ? "Create Account" : "Submit",
                                  fontweight: FontWeight.w600,
                                  fontsize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              TextHelper(text: "Or Sign in with", color: Colors.blueGrey.shade400, textalign: TextAlign.center),
                              ButtonHelperG(
                                onTap: () async {
                                  MainStore mainStore = Get.find<MainStore>();
                                  await mainStore.firebaseG.makeProviderLogin(AuthType.google);
                                },
                                borderRadius: 60,
                                width: MediaQuery.sizeOf(context).width * 0.8 > 300 ? 300 : MediaQuery.sizeOf(context).width * 0.8,
                                background: Colors.white,
                                withBorder: true,
                                shadow: [],
                                borderColor: Colors.blueGrey.shade400,
                                label: TextHelper(
                                  text: 'Continue with Google',
                                  fontweight: FontWeight.w600,
                                  color: Colors.blueGrey.shade600,
                                  fontsize: 14,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                                icon: Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: Image.asset('assets/google.png', width: 20)),
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     TextHelper(
                              //       text: isCreateAccount ? "Already have an account?" : "Want to create an account?",
                              //       color: Colors.blueGrey.shade400,
                              //       textalign: TextAlign.center,
                              //     ),
                              //     ButtonHelperG(
                              //       onTap: changeLoginMode,
                              //       label: TextHelper(text: "Click here"),
                              //       height: 25,
                              //       background: Colors.transparent,
                              //       padding: EdgeInsets.zero,
                              //       width: 70,
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
