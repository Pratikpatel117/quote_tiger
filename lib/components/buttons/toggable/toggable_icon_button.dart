import 'package:flutter/material.dart';

import '../../icons/qicon.dart';
import '../filled_icon_button.dart';

class OldToggableFilledIconButton extends StatefulWidget {
  final IconData icon;
  final Function(bool state) onToggle;
  final bool isActive;
  final double size;
  const OldToggableFilledIconButton(
      {Key? key,
      required this.icon,
      this.size = 40,
      required this.onToggle,
      this.isActive = false})
      : super(key: key);

  @override
  State<OldToggableFilledIconButton> createState() =>
      _OldToggableFilledIconButtonState();
}

class _OldToggableFilledIconButtonState
    extends State<OldToggableFilledIconButton> {
  bool buttonState = false;
  @override
  void initState() {
    buttonState = widget.isActive;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OldFilledIconButton(
      size: widget.size,
      onPressed: () {
        widget.onToggle(buttonState);
        setState(() {
          buttonState = !buttonState;
        });
      },
      icon: widget.icon,
      active: buttonState,
    );
  }
}

class ToggableFilledIconButton extends StatefulWidget {
  final QIconData icon;
  final Function(bool state) onToggle;
  final bool isActive;
  final double size;
  const ToggableFilledIconButton(
      {Key? key,
      required this.icon,
      this.size = 40,
      required this.onToggle,
      this.isActive = false})
      : super(key: key);

  @override
  State<ToggableFilledIconButton> createState() =>
      _ToggableFilledIconButtonState();
}

class _ToggableFilledIconButtonState extends State<ToggableFilledIconButton> {
  bool buttonState = false;
  @override
  void initState() {
    buttonState = widget.isActive;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FilledIconButton(
      size: widget.size,
      onPressed: () {
        widget.onToggle(buttonState);
        setState(() {
          buttonState = !buttonState;
        });
      },
      icon: widget.icon,
      active: buttonState,
    );
  }
}

class OldStatelessToggableFilledIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onToggle;
  final bool isActive;
  final double size;
  final Color passiveFillColor;
  final Color activeFillColor;
  final Color passiveImageColor;
  final Color activeImageColor;

  const OldStatelessToggableFilledIconButton({
    Key? key,
    required this.icon,
    required this.onToggle,
    this.size = 40,
    this.isActive = false,
    this.passiveFillColor = const Color(0xFFFAFAFA),
    this.activeFillColor = const Color(0xFFFFE5B9),
    this.passiveImageColor = Colors.black,
    this.activeImageColor = const Color(0xFFD48700),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OldFilledIconButton(
      passiveFillColor: passiveFillColor,
      activeIconColor: activeImageColor,
      passiveIconColor: passiveImageColor,
      activeFillColor: activeFillColor,
      size: size,
      onPressed: onToggle,
      icon: icon,
      active: isActive,
    );
  }
}

class StatelessToggableFilledIconButton extends StatelessWidget {
  final QIconData icon;
  final VoidCallback onToggle;
  final bool isActive;
  final double size;
  final Color passiveFillColor;
  final Color activeFillColor;
  final Color passiveImageColor;
  final Color activeImageColor;

  const StatelessToggableFilledIconButton({
    Key? key,
    required this.icon,
    required this.onToggle,
    this.size = 40,
    this.isActive = false,
    this.passiveFillColor = const Color(0xFFf4f5f6),
    this.activeFillColor = const Color(0xFFFFE5B9),
    this.passiveImageColor = const Color(0xFF525256),
    this.activeImageColor = const Color(0xFFD48700),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilledIconButton(
      passiveFillColor: passiveFillColor,
      activeIconColor: activeImageColor,
      passiveIconColor: passiveImageColor,
      activeFillColor: activeFillColor,
      size: size,
      onPressed: onToggle,
      icon: icon,
      active: isActive,
    );
  }
}
