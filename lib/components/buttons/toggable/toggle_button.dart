import 'package:flutter/material.dart';
import 'package:quote_tiger/components/buttons/empty_button.dart';
import 'package:quote_tiger/components/buttons/filled_button.dart';

import '../../icons/qicon.dart';

// QIcon(
//                     QIcons.message,
//                     color: Colors.white,
//                     size: 25,
//                   ),
class OldCustomToggableIconButton extends StatefulWidget {
  final double width;
  final double height;
  final QIconData icon;
  final Function(bool state) onToggle;
  final bool isActive;
  const OldCustomToggableIconButton(
      {Key? key,
      required this.icon,
      required this.onToggle,
      this.width = 100,
      this.height = 100,
      this.isActive = false})
      : super(key: key);

  @override
  State<OldCustomToggableIconButton> createState() =>
      _OldCustomToggableIconButtonState();
}

class _OldCustomToggableIconButtonState
    extends State<OldCustomToggableIconButton> {
  bool buttonState = false;

  @override
  void initState() {
    buttonState = widget.isActive;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (buttonState) {
      return CustomFilledButton(
        width: widget.width,
        height: widget.height,
        onPressed: () {
          widget.onToggle(buttonState);

          setState(() {
            buttonState = !buttonState;
          });
        },
        child: QIcon(
          widget.icon,
          color: Colors.white,
        ),
      );
    }
    return EmptyTextButton(
      borderColor: const Color(0xFFFCA205),
      width: widget.width,
      height: widget.height,
      onPressed: () {
        widget.onToggle(buttonState);

        setState(() {
          buttonState = !buttonState;
        });
      },
      child: QIcon(
        widget.icon,
        color: const Color(0xFFFCA205),
      ),
    );
  }
}

class CustomToggableIconButton extends StatefulWidget {
  final double width;
  final double height;
  final IconData icon;
  final Function(bool state) onToggle;
  final bool isActive;
  const CustomToggableIconButton(
      {Key? key,
      required this.icon,
      required this.onToggle,
      this.width = 100,
      this.height = 100,
      this.isActive = false})
      : super(key: key);

  @override
  State<CustomToggableIconButton> createState() =>
      _CustomToggableIconButtonState();
}

class _CustomToggableIconButtonState extends State<CustomToggableIconButton> {
  bool buttonState = false;

  @override
  void initState() {
    buttonState = widget.isActive;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (buttonState) {
      return CustomFilledButton(
        width: widget.width,
        height: widget.height,
        onPressed: () {
          widget.onToggle(buttonState);

          setState(() {
            buttonState = !buttonState;
          });
        },
        child: Icon(
          widget.icon,
          color: Colors.white,
        ),
      );
    }
    return EmptyTextButton(
      borderColor: const Color(0xFFFCA205),
      width: widget.width,
      height: widget.height,
      onPressed: () {
        widget.onToggle(buttonState);

        setState(() {
          buttonState = !buttonState;
        });
      },
      child: Icon(
        widget.icon,
        color: const Color(0xFFFCA205),
      ),
    );
  }
}
