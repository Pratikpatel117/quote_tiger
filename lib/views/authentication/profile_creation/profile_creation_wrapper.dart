import 'package:flutter/material.dart';
import 'package:quote_tiger/views/authentication/profile_creation/profile_creator.dart';
import 'package:quote_tiger/views/authentication/profile_creation/sector_picker.dart';

class ProfileCreationWrapper extends StatefulWidget {
  const ProfileCreationWrapper({Key? key}) : super(key: key);

  @override
  State<ProfileCreationWrapper> createState() => _ProfileCreationWrapperState();
}

class _ProfileCreationWrapperState extends State<ProfileCreationWrapper> {
  final PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          pageSnapping: true,
          controller: controller,
          scrollDirection: Axis.vertical,
          children: [
            ProfileCreator(
              controller: controller,
            ),
            SectorPicker(
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}
