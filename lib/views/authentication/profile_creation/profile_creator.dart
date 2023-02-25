import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:quote_tiger/components/country_picker.dart';
import 'package:quote_tiger/components/logos/trademark.dart';
import 'package:quote_tiger/components/notifications/info_dialog.dart';
import 'package:quote_tiger/provider/auth_provider.dart';
import 'package:quote_tiger/services/user.dart';
import '../../../components/buttons/filled_button.dart';
import '../../../components/input_fields/tiger/quote_tiger_input_field.dart';
import '../../../components/lists/signup_timeline.dart';

extension EmailValidator on String {
  bool get isValidEmail {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class ProfileCreator extends StatefulWidget {
  final PageController controller;
  const ProfileCreator({Key? key, required this.controller}) : super(key: key);

  @override
  State<ProfileCreator> createState() => _ProfileCreatorState();
}

class _ProfileCreatorState extends State<ProfileCreator> {
  Future<String?> validateInput(AuthProvider authProvider) async {
    if (authProvider.fullnameController.text == '') {
      return 'You need to provide your name';
    }

    if (authProvider.usernameController.text == '') {
      return 'You need to provide a username';
    }

    if (authProvider.usernameController.text.length > 20) {
      return 'Username is too long';
    }

    if (await UserService.checkIfUsernameInUse(
        authProvider.usernameController.text)) {
      return 'Username has to be unique';
    }

    if (authProvider.locationController.text == '' ||
        authProvider.locationController.text == 'Country') {
      return 'You need to provide a country';
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
            const Center(
              child: Trademark(),
            ),
            const SizedBox(
              height: 10,
            ),
            const SignUpSteps(
              currentIndex: 2,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Profile Details',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.7,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            QuoteTigerInputField(
                controller: authProvider.fullnameController,
                hint: 'e.g John Doe',
                message: 'Full Name'),
            QuoteTigerInputField(
                controller: authProvider.usernameController,
                hint: 'Enter your username',
                message: 'Username'),
            QuoteTigerInputField(
                controller: authProvider.companyController,
                hint: 'Enter your company\'s name',
                message: 'Company name (optional)'),
            CountryPicker(
              controller: authProvider.locationController,
              initialValue: "Pick Country",
              title: "Your country",
            ),
            const SizedBox(
              height: 12,
            ),
            FilledTextButton(
                width: MediaQuery.of(context).size.width,
                height: 72,
                onPressed: () async {
                  //create the user
                  var validationResponse = await validateInput(authProvider);
                  if (validationResponse != null) {
                    showError(context, validationResponse);
                  } else {
                    widget.controller.animateToPage(1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutSine);
                  }
                },
                message: 'Continue'),
          ],
        ),
      ),
    );
  }
}
