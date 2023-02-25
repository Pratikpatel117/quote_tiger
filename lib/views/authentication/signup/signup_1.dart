import 'package:flutter_svg/flutter_svg.dart';
import 'package:quote_tiger/components/buttons/go_back_button.dart';
import 'package:quote_tiger/components/buttons/checkboxes/terms_and_services_checkbox.dart';
import 'package:quote_tiger/components/input_fields/tiger/quote_tiger_input_field.dart';
import 'package:quote_tiger/components/lists/signup_timeline.dart';
import 'package:quote_tiger/components/logos/trademark.dart';
import 'package:quote_tiger/components/notifications/info_dialog.dart';
import 'package:quote_tiger/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quote_tiger/services/user.dart';

import '../../../components/buttons/empty_button.dart';
import '../../../components/buttons/filled_button.dart';

extension EmailValidator on String {
  bool get isValidEmail {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class SignupPage1 extends StatefulWidget {
  final PageController controller;
  const SignupPage1({Key? key, required this.controller}) : super(key: key);

  @override
  State<SignupPage1> createState() => _SignupPage1State();
}

class _SignupPage1State extends State<SignupPage1> {
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  final TextEditingController controller = TextEditingController();
  final CheckBoxController checkBoxController = CheckBoxController();

  Future<String?> validateInput(AuthProvider authProvider) async {
    if (authProvider.emailController.text == '') {
      return 'You need to provide an email';
    }
    if (!authProvider.emailController.text.isValidEmail) {
      return 'Email is not valid';
    }
    if (!checkBoxController.value) {
      return 'You need to accept the terms and services';
    }
    if (authProvider.passwordController.text == '') {
      return 'You need to provide a password';
    }
    if (passwordConfirmationController.text == '') {
      return 'You need to provide a confirmation password';
    }
    if (await UserService.checkIfEmailInUse(
        authProvider.emailController.text)) {
      return 'Email already in use';
    }

    if (authProvider.passwordController.text.length < 8) {
      return 'Password needs to be longer';
    }

    if (passwordConfirmationController.text !=
        authProvider.passwordController.text) {
      return 'Passwords don\'t match';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GoBackButton(context),
                const Trademark(),
                const SizedBox(
                  width: 40,
                  height: 40,
                )
              ],
            ),
            const Text(
              'Create an account',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.3,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SignUpSteps(
              currentIndex: 1,
            ),
            const SizedBox(
              height: 26,
            ),
            QuoteTigerInputField(
                controller: authProvider.emailController,
                hint: 'Enter your email address',
                message: 'Email address'),
            QuoteTigerInputField(
                controller: authProvider.passwordController,
                isPassword: true,
                hint: 'Enter your password',
                message: 'Password'),
            QuoteTigerInputField(
                isPassword: true,
                controller: passwordConfirmationController,
                hint: 'Enter your password again',
                message: 'Confirm Password'),
            const Divider(),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Or connect using your social media',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                EmptyTextButton(
                  height: 64,
                  width: 64,
                  borderColor: const Color(0xFFEAEAEB),
                  borderRadius: BorderRadius.circular(15),
                  onPressed: () async {
                    var error = await authProvider.signInWithGoogle();
                    if (error == null) {
                      Navigator.pop(context);
                    } else {
                      showError(context, error);
                    }
                  },
                  child: SvgPicture.asset('assets/logos/google.svg'),
                ),
                EmptyTextButton(
                  height: 64,
                  width: 64,
                  borderColor: const Color(0xFFEAEAEB),
                  borderRadius: BorderRadius.circular(15),
                  onPressed: () async {
                    var error = await authProvider.signInWithTwitter();
                    if (error == null) {
                      Navigator.pop(context);
                    } else {
                      showError(context, error);
                    }
                  },
                  child: SvgPicture.asset('assets/logos/twitter.svg'),
                ),
                EmptyTextButton(
                  height: 64,
                  width: 64,
                  borderColor: const Color(0xFFEAEAEB),
                  borderRadius: BorderRadius.circular(15),
                  onPressed: () {},
                  child: SvgPicture.asset('assets/logos/apple.svg'),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            TermsAndServicesCheckbox(controller: checkBoxController),
            const SizedBox(
              height: 12,
            ),
            FilledTextButton(
                width: MediaQuery.of(context).size.width,
                height: 72,
                onPressed: () async {
                  var validationResponse = await validateInput(authProvider);
                  if (validationResponse == null) {
                    widget.controller.animateToPage(1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutSine);
                  } else {
                    showError(context, validationResponse);
                  }
                },
                message: 'Continue'),
          ],
        ),
      ),
    );
  }
}
