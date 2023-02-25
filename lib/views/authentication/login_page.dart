import 'package:flutter_svg/svg.dart';
import 'package:quote_tiger/components/buttons/go_back_button.dart';
import 'package:quote_tiger/components/buttons/empty_button.dart';
import 'package:quote_tiger/components/input_fields/standard_input_field.dart';
import 'package:quote_tiger/components/notifications/info_dialog.dart';
import 'package:quote_tiger/provider/auth_provider.dart';
import 'package:quote_tiger/views/authentication/forgot_password_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quote_tiger/views/authentication/signup/signup_wrapper.dart';

import '../../components/buttons/filled_button.dart';
import '../../components/logos/trademark.dart';
import '../../utils/push.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GoBackButton(context),
                  const Trademark(),
                  const SizedBox(
                    width: 40,
                  ),
                ],
              ),
              const Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.3,
                ),
              ),
              const Text(
                'Enter your login information to get access to your account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF97979B),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email address',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextInputField(
                    controller: authProvider.emailController,
                    hint: 'Enter your email address',
                    prefix: const Icon(Icons.person_outline),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextInputField(
                    controller: authProvider.passwordController,
                    hint: 'Password',
                    isPassword: true,
                    prefix: const Icon(Icons.lock_open),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      push(context, const ForgotPasswordPage());
                    },
                    child: Text(
                      'Forgot your password?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              FilledTextButton(
                  width: MediaQuery.of(context).size.width,
                  onPressed: () async {
                    var error = await authProvider.signIn();

                    if (error != null) {
                      showError(context, error);
                      return;
                    }
                    authProvider.clearControllers();
                    Navigator.pop(context);
                  },
                  message: 'Log into your account'),
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Or connect using your social media',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
                height: 20,
              ),
              const Text(
                'You don\'t have an account?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpWrapper()),
                  );
                },
                child: Text(
                  'Click here to create an account',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 17),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
