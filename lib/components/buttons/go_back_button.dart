import 'package:flutter/material.dart';

import '../icons/qicon.dart';
import 'filled_icon_button.dart';

class GoBackButton extends StatelessWidget {
  final BuildContext context;
  final double size;
  final VoidCallback? onPressed;
  final bool isPopUp;
  const GoBackButton(this.context,
      {Key? key, this.size = 40, this.onPressed, this.isPopUp = false})
      : super(key: key);

  QIconData getIcon() {
    if (isPopUp) return QIcons.close;
    return QIcons.arrow;
  }

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext _context) {
    return SizedBox(
      child: FilledIconButton(
        padding: const EdgeInsets.all(6),
        icon: getIcon(),
        size: size,
        onPressed: onPressed ??
            () {
              Navigator.pop(context);
            },
      ),
    );
  }
}
