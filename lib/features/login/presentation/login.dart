import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';

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
        loaderController.startLoading();
        user.checkIfUserLogin().whenComplete(() {
          loaderController.stopLoading();
        });
      } catch (e) {
        showAlert("$e", AlertType.error);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 50),
          TextHelper(
            text: "Health & Wellness",
            fontsize: 25,
            fontweight: FontWeight.w600,
            color: Colors.blueGrey.shade700,
            textalign: TextAlign.center,
            padding: EdgeInsets.all(30),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.7,
            child: Center(
              child: Container(
                margin: EdgeInsets.all(12),
                padding: EdgeInsets.all(22),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                child: Column(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextHelper(text: isCreateAccount ? "Create an Account?" : "Login", textalign: TextAlign.center, fontweight: FontWeight.w600, fontsize: 19),
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
                                withBorder: false,
                                backgroundColor: Colors.blueGrey.shade200.withAlpha(50),
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
                              leading: Icon(Icons.mail, size: 20, color: Colors.blueGrey.shade400),
                              borderRadius: 30,
                              withBorder: false,
                              backgroundColor: Colors.blueGrey.shade200.withAlpha(50),
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
                              leading: Icon(Icons.password, size: 20, color: Colors.blueGrey.shade400),
                              borderRadius: 30,
                              withBorder: false,
                              obscureText: !showPassword,
                              backgroundColor: Colors.blueGrey.shade200.withAlpha(50),
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
                            bool redirect = await user.emailLogin(email: emailController.text, password: passwordController.text);
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
                      width: 350,
                      borderRadius: 20,
                      label: TextHelper(text: isCreateAccount ? "Create Account" : "Submit", fontweight: FontWeight.w600, fontsize: 12, color: Colors.white),
                    ),
                    TextHelper(text: "Or Sign in with", color: Colors.blueGrey.shade400, textalign: TextAlign.center),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonHelperG(
                          onTap: () async {
                            MainStore mainStore = Get.find<MainStore>();
                            await mainStore.firebaseG.makeProviderLogin(AuthType.google);
                          },
                          borderRadius: 60,
                          width: 350,
                          background: Colors.grey.shade100,
                          shadow: [],
                          label: TextHelper(
                            text: 'Continue with Google',
                            fontweight: FontWeight.w600,
                            color: Colors.blueGrey.shade600,
                            fontsize: 14,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                          icon: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Icon(FontAwesomeIcons.google, size: 18, color: Colors.blueGrey),
                          ),
                        ),
                        // ButtonHelperG(
                        //   borderRadius: 60,
                        //   background: Colors.grey.shade100,
                        //   shadow: [],
                        //   icon: Icon(FontAwesomeIcons.facebook, size: 18, color: Colors.blue),
                        // ),
                        // ButtonHelperG(
                        //   borderRadius: 60,
                        //   background: Colors.grey.shade100,
                        //   shadow: [],
                        //   icon: Icon(FontAwesomeIcons.twitter, size: 18, color: Colors.black),
                        // ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextHelper(
                          text: isCreateAccount ? "Already have an account?" : "Want to create an account?",
                          color: Colors.blueGrey.shade400,
                          textalign: TextAlign.center,
                        ),
                        ButtonHelperG(
                          onTap: changeLoginMode,
                          label: TextHelper(text: "Click here"),
                          height: 25,
                          background: Colors.transparent,
                          padding: EdgeInsets.zero,
                          width: 70,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
