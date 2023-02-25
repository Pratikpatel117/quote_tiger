import 'package:flutter/material.dart';
import 'package:quote_tiger/components/buttons/go_back_button.dart';

import 'package:provider/provider.dart';
import 'package:quote_tiger/components/buttons/filled_button.dart';
import 'package:quote_tiger/components/notifications/info_dialog.dart';
import 'package:quote_tiger/components/scrollables/sector_category_list.dart';
import 'package:quote_tiger/components/logos/trademark.dart';
import 'package:quote_tiger/provider/auth_provider.dart';
import 'package:quote_tiger/services/sector_service.dart';

import '../../../components/lists/signup_timeline.dart';
import '../../../models/sector/empty_sector_category_model.dart';

class SectorPicker extends StatefulWidget {
  final PageController controller;

  const SectorPicker({Key? key, required this.controller}) : super(key: key);

  @override
  State<SectorPicker> createState() => _SectorPickerState();
}

class _SectorPickerState extends State<SectorPicker> {
  String? validateInput(AuthProvider provider) {
    if (provider.sectorPickerController.getSectorModels.isEmpty) {
      return 'Please Pick Atleast One Sector of Interest';
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
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 24,
                    )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const SignUpSteps(
              currentIndex: 3,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Choose Sectors',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.7,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const SizedBox(
              height: 12,
            ),
            FutureBuilder(
              future: SectorService().getEmptySectorCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Text('An error has occurred');
                }

                if (!snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return const Text('Category is empty');
                }
                List<EmptySectorCategoryModel> models =
                    snapshot.data as List<EmptySectorCategoryModel>;
                return SectorCategoriesWidget(models: models);
              },
            ),
            FilledTextButton(
              width: MediaQuery.of(context).size.width,
              onPressed: () async {
                var validationResponse = validateInput(authProvider);

                if (validationResponse != null) {
                  showError(context, validationResponse);
                } else {
                  var error = await authProvider.createAccount();

                  if (error != null) {
                    showError(context, error);
                  } else {
                    authProvider.clearControllers();
                  }
                }
              },
              message: 'Finish your acount',
            )
          ],
        ),
      ),
    );
  }
}
