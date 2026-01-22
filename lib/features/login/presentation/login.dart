import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthandwellness/core/utility/helper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextHelper(
              text: "Health & Wellness",
              fontsize: 25,
              fontweight: FontWeight.w600,
              color: Colors.blueGrey.shade700,
              textalign: TextAlign.center,
              padding: EdgeInsets.all(30),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
            Container(
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.all(22),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Column(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextHelper(text: "Create an Account?", textalign: TextAlign.center, fontweight: FontWeight.w600, fontsize: 19),
                  Column(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        spacing: 6,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextHelper(text: "Name", fontweight: FontWeight.w600),
                          TextBox(
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
                            leading: Icon(Icons.password, size: 20, color: Colors.blueGrey.shade400),
                            borderRadius: 30,
                            withBorder: false,
                            backgroundColor: Colors.blueGrey.shade200.withAlpha(50),
                            trailing: ButtonHelperG(
                              background: Colors.transparent,
                              width: 25,
                              icon: Icon(Icons.remove_red_eye_sharp, size: 18, color: Colors.blueGrey.shade400),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ButtonHelperG(
                    width: 350,
                    borderRadius: 20,
                    label: TextHelper(text: "Create Account", fontweight: FontWeight.w600, fontsize: 12, color: Colors.white),
                  ),
                  TextHelper(text: "Or Sign in with", color: Colors.blueGrey.shade400, textalign: TextAlign.center),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonHelperG(
                        borderRadius: 60,
                        background: Colors.grey.shade100,
                        shadow: [],
                        icon: Icon(FontAwesomeIcons.google, size: 18, color: Colors.orange),
                      ),
                      ButtonHelperG(
                        borderRadius: 60,
                        background: Colors.grey.shade100,
                        shadow: [],
                        icon: Icon(FontAwesomeIcons.facebook, size: 18, color: Colors.blue),
                      ),
                      ButtonHelperG(
                        borderRadius: 60,
                        background: Colors.grey.shade100,
                        shadow: [],
                        icon: Icon(FontAwesomeIcons.twitter, size: 18, color: Colors.black),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextHelper(text: "Already have an account?", color: Colors.blueGrey.shade400, textalign: TextAlign.center),
                      ButtonHelperG(
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
          ],
        ),
      ),
    );
  }
}
