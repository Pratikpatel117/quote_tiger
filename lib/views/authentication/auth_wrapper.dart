import 'package:flutter/material.dart';

import 'package:quote_tiger/views/authentication/login_page.dart';
import 'package:quote_tiger/views/authentication/signup/signup_wrapper.dart';

import '../../components/buttons/empty_button.dart';
import '../../components/buttons/filled_button.dart';
import '../../utils/push.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                SizedBox(
                  width: 190,
                  child: Image.asset(
                    'assets/logo/banner2.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Column(
                  children: [
                    const Text(
                      'Opportunity awaits.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.02,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        EmptyTextButton(
                          onPressed: () => push(
                            context,
                            const LoginPage(),
                          ),
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                                color: Colors.orange,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        FilledTextButton(
                          onPressed: () => push(
                            context,
                            const SignUpWrapper(),
                          ),
                          message: 'Sign up',
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyLocalButton extends StatefulWidget {
  final VoidCallback onPresed;
  final String message;
  final double width;
  final double height;

  const EmptyLocalButton({
    Key? key,
    required this.onPresed,
    required this.message,
    this.height = 160,
    this.width = 64,
  }) : super(key: key);

  @override
  State<EmptyLocalButton> createState() => _EmptyLocalButtonState();
}

class _EmptyLocalButtonState extends State<EmptyLocalButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 160,
        height: 64,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange, width: 2),
          borderRadius: BorderRadius.circular(6),
        ),
        child: TextButton(
          onPressed: widget.onPresed,
          child: Text(
            widget.message,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ));
  }
}

class FilledLocalButton extends StatefulWidget {
  final VoidCallback onPresed;
  final String message;

  const FilledLocalButton(
      {Key? key, required this.onPresed, required this.message})
      : super(key: key);

  @override
  State<FilledLocalButton> createState() => _FilledLocalButtonState();
}

class _FilledLocalButtonState extends State<FilledLocalButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 160,
        height: 64,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [
                0.5,
                0.9,
              ],
              colors: [
                Color(0xFFFCA205),
                Color(0xFFFFC55F),
              ],
            )),
        child: TextButton(
            onPressed: widget.onPresed,
            child: Text(
              widget.message,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            )));
  }
}
