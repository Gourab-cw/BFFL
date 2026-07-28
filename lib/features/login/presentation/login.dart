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
    Future(() async {
      try {
        if (GetPlatform.isWindows) {
          loaderController.startLoading();
          await user.checkIfUserLogin().whenComplete(() {
            loaderController.stopLoading();
          });
        }
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
      backgroundColor: mainStore.theme.value.BackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top App Logo & Branding Header
                // Container(
                //   width: 64,
                //   height: 64,
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       colors: [
                //         mainStore.theme.value.HeadColor,
                //         mainStore.theme.value.HeadColor.withAlpha(200),
                //       ],
                //       begin: Alignment.topLeft,
                //       end: Alignment.bottomRight,
                //     ),
                //     shape: BoxShape.circle,
                //     boxShadow: [
                //       BoxShadow(
                //         color: mainStore.theme.value.HeadColor.withAlpha(60),
                //         blurRadius: 16,
                //         offset: const Offset(0, 6),
                //       ),
                //     ],
                //   ),
                //   child: const Center(
                //     child: Icon(
                //       Icons.fitness_center_rounded,
                //       size: 32,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 14),
                TextHelper(
                  text: "Health & Wellness",
                  fontsize: 24,
                  fontweight: FontWeight.w800,
                  color: Colors.blueGrey.shade900,
                  textalign: TextAlign.center,
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(height: 4),
                TextHelper(
                  text: isCreateAccount
                      ? "Sign up to start your wellness journey"
                      : "Welcome back! Please sign in to continue",
                  fontsize: 12.5,
                  color: Colors.grey.shade600,
                  textalign: TextAlign.center,
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(height: 24),

                // Main Login Card
                AnimatedOpacity(
                  opacity: opacity == 0 ? 1.0 : opacity,
                  duration: const Duration(milliseconds: 600),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 420),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(12),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Title Tag
                        Center(
                          child: TextHelper(
                            text: isCreateAccount
                                ? "Create Account"
                                : "Sign In",
                            textalign: TextAlign.center,
                            color: Colors.blueGrey.shade900,
                            fontweight: FontWeight.w800,
                            fontsize: 20,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Form Inputs
                        Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isCreateAccount) ...[
                                TextHelper(
                                  text: "Full Name",
                                  fontweight: FontWeight.w700,
                                  fontsize: 12.5,
                                  color: Colors.blueGrey.shade800,
                                  padding: EdgeInsets.zero,
                                ),
                                const SizedBox(height: 6),
                                TextBox(
                                  controller: nameController,
                                  placeholder: "Enter your full name",
                                  leading: Icon(
                                    Icons.person_outline_rounded,
                                    size: 20,
                                    color: Colors.blueGrey.shade400,
                                  ),
                                  borderRadius: 14,
                                  backgroundColor: Colors.grey.shade50,
                                ),
                                const SizedBox(height: 16),
                              ],

                              TextHelper(
                                text: "Email Address",
                                fontweight: FontWeight.w700,
                                fontsize: 12.5,
                                color: Colors.blueGrey.shade800,
                                padding: EdgeInsets.zero,
                              ),
                              const SizedBox(height: 6),
                              FormField(
                                autovalidateMode: AutovalidateMode.always,
                                builder: (formFieldState) {
                                  return TextBox(
                                    controller: emailController,
                                    placeholder: "name@example.com",
                                    onValueChange: (v) {
                                      formFieldState.didChange;
                                    },
                                    keyboard: TextInputType.emailAddress,
                                    autofillHints: const [AutofillHints.email],
                                    leading: Icon(
                                      Icons.mail_outline_rounded,
                                      size: 20,
                                      color: Colors.blueGrey.shade400,
                                    ),
                                    borderRadius: 14,
                                    backgroundColor: Colors.grey.shade50,
                                  );
                                },
                              ),
                              const SizedBox(height: 16),

                              TextHelper(
                                text: "Password",
                                fontweight: FontWeight.w700,
                                fontsize: 12.5,
                                color: Colors.blueGrey.shade800,
                                padding: EdgeInsets.zero,
                              ),
                              const SizedBox(height: 6),
                              FormField(
                                autovalidateMode: AutovalidateMode.always,
                                builder: (formFieldState) {
                                  return TextBox(
                                    controller: passwordController,
                                    placeholder: "••••••••",
                                    leading: Icon(
                                      Icons.lock_outline_rounded,
                                      size: 20,
                                      color: Colors.blueGrey.shade400,
                                    ),
                                    borderRadius: 14,
                                    autofillHints: const [
                                      AutofillHints.password,
                                    ],
                                    obscureText: !showPassword,
                                    backgroundColor: Colors.grey.shade50,
                                    keyboard: TextInputType.visiblePassword,
                                    onValueChange: (v) {
                                      formFieldState.didChange;
                                    },
                                    trailing: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showPassword = !showPassword;
                                        });
                                      },
                                      icon: Icon(
                                        showPassword
                                            ? Icons.visibility_rounded
                                            : Icons.visibility_off_rounded,
                                        size: 18,
                                        color: Colors.blueGrey.shade400,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 22),

                              // Submit Button
                              InkWell(
                                onTap: () async {
                                  loaderController.startLoading();
                                  if (isCreateAccount) {
                                    try {
                                      await user.addUser(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        name: nameController.text,
                                      );
                                    } catch (e) {
                                      showAlert("$e", AlertType.error);
                                    } finally {
                                      loaderController.stopLoading();
                                    }
                                  } else {
                                    try {
                                      bool redirect = await user.emailLogin(
                                        email: emailController.text.trim(),
                                        password: passwordController.text
                                            .trim(),
                                      );
                                      if (redirect) {
                                        Get.offAllNamed("/");
                                      }
                                    } catch (e) {
                                      showAlert("$e", AlertType.error);
                                    } finally {
                                      loaderController.stopLoading();
                                    }
                                  }
                                },
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  width: double.infinity,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        mainStore.theme.value.HeadColor,
                                        mainStore.theme.value.HeadColor
                                            .withAlpha(210),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: mainStore.theme.value.HeadColor
                                            .withAlpha(60),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextHelper(
                                        text: isCreateAccount
                                            ? "Create Account"
                                            : "Sign In",
                                        fontweight: FontWeight.w700,
                                        fontsize: 14,
                                        color: Colors.white,
                                        padding: EdgeInsets.zero,
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // OR Divider
                        Row(
                          children: [
                            Expanded(
                              child: Divider(color: Colors.grey.shade200),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: TextHelper(
                                text: "OR CONTINUE WITH",
                                fontsize: 10,
                                fontweight: FontWeight.w700,
                                color: Colors.grey.shade500,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            Expanded(
                              child: Divider(color: Colors.grey.shade200),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Google Sign In Button
                        InkWell(
                          onTap: () async {
                            MainStore mainStore = Get.find<MainStore>();
                            await mainStore.firebaseG.makeProviderLogin(
                              AuthType.google,
                            );
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            width: double.infinity,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/google.png',
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(width: 10),
                                TextHelper(
                                  text: 'Continue with Google',
                                  fontweight: FontWeight.w700,
                                  color: Colors.blueGrey.shade800,
                                  fontsize: 13,
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Mode Toggle Row
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     TextHelper(
                        //       text: isCreateAccount ? "Already have an account?" : "Don't have an account?",
                        //       color: Colors.grey.shade600,
                        //       fontsize: 12.5,
                        //       padding: EdgeInsets.zero,
                        //     ),
                        //     const SizedBox(width: 6),
                        //     GestureDetector(
                        //       onTap: changeLoginMode,
                        //       child: TextHelper(
                        //         text: isCreateAccount ? "Sign In" : "Sign Up",
                        //         color: mainStore.theme.value.HeadColor,
                        //         fontweight: FontWeight.w700,
                        //         fontsize: 12.5,
                        //         padding: EdgeInsets.zero,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
