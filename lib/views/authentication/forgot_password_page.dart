import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:quote_tiger/components/buttons/filled_button.dart';
import 'package:quote_tiger/components/buttons/go_back_button.dart';
import 'package:quote_tiger/components/logos/trademark.dart';
import 'package:quote_tiger/components/notifications/info_dialog.dart';

import '../../components/input_fields/standard_input_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Stack(
            children: [
              Column(
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
                    'Reset your password',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.3,
                    ),
                  ),
                  const Text(
                    'Enter your email address to receive further instructions on reseting your password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF97979B),
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1.3,
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
                        controller: emailController,
                        hint: 'Enter your email address',
                        prefix: const Icon(Icons.person_outline),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  FilledTextButton(
                      width: MediaQuery.of(context).size.width,
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: emailController.text);
                          showInfo(context,
                              'An email has been send to ${emailController.text}');

                          Navigator.pop(context);
                        } catch (e) {
                          showError(context, '$e');
                        }
                      },
                      message: 'Reset Password'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
