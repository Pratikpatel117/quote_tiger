import 'package:flutter/material.dart';
import 'package:quote_tiger/views/authentication/signup/signup_1.dart';
import 'package:quote_tiger/views/authentication/signup/signup_2.dart';
import 'package:quote_tiger/views/authentication/signup/signup_3.dart';

class SignUpWrapper extends StatefulWidget {
  const SignUpWrapper({Key? key}) : super(key: key);

  @override
  State<SignUpWrapper> createState() => _SignUpWrapperState();
}

class _SignUpWrapperState extends State<SignUpWrapper> {
  final PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          pageSnapping: true,
          controller: controller,
          scrollDirection: Axis.vertical,
          children: [
            SignupPage1(
              controller: controller,
            ),
            SignUpPage2(
              controller: controller,
            ),
            SignUpPage3(
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}
