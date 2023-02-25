import 'package:flutter/material.dart';

import '../icons/qicon.dart';

class OldFilledIconButton extends StatefulWidget {
  final IconData icon;

  final Color passiveFillColor;
  final Color activeFillColor;

  final Color passiveIconColor;
  final Color activeIconColor;

  final VoidCallback? onPressed;
  final double size;
  final bool active;

  const OldFilledIconButton(
      {Key? key,
      required this.icon,
      this.passiveFillColor = const Color(0xFFFAFAFA),
      this.activeFillColor = const Color(0xFFFFE5B9),
      this.passiveIconColor = Colors.black,
      this.activeIconColor = const Color(0xFFD48700),
      this.onPressed,
      this.active = false,
      this.size = 40})
      : super(key: key);

  @override
  State<OldFilledIconButton> createState() => _OldFilledIconButtonState();
}

class _OldFilledIconButtonState extends State<OldFilledIconButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      customBorder: const CircleBorder(),
      child: Ink(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              widget.active ? widget.activeFillColor : widget.passiveFillColor,
        ),
        child: Icon(
          widget.icon,
          color:
              widget.active ? widget.activeIconColor : widget.passiveIconColor,
          size: widget.size / 2,
        ),
      ),
    );
  }
}

class FilledIconButton extends StatefulWidget {
  final QIconData icon;

  final Color passiveFillColor;
  final Color activeFillColor;

  final Color passiveIconColor;
  final Color activeIconColor;

  final VoidCallback? onPressed;
  final double size;
  final bool active;
  final EdgeInsets padding;

  const FilledIconButton(
      {Key? key,
      required this.icon,
      this.padding = const EdgeInsets.all(10),
      this.passiveFillColor = const Color(0xFFf4f5f6),
      this.activeFillColor = const Color(0xFFFFE5B9),
      this.passiveIconColor = const Color(0xFF525256),
      this.activeIconColor = const Color(0xFFD48700),
      this.onPressed,
      this.active = false,
      this.size = 40})
      : super(key: key);

  @override
  State<FilledIconButton> createState() => _FilledIconButtonState();
}

class _FilledIconButtonState extends State<FilledIconButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      customBorder: const CircleBorder(),
      child: Ink(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              widget.active ? widget.activeFillColor : widget.passiveFillColor,
        ),
        child: Padding(
          padding: widget.padding,
          child: QIcon(
            widget.icon,
            color: widget.active
                ? widget.activeIconColor
                : widget.passiveIconColor,
            size: widget.size / 2,
          ),
        ),
      ),
    );
  }
}
