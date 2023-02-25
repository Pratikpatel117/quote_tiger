import 'package:flutter/material.dart';

class EmptyTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double width;
  final double height;
  final Color borderColor;
  final BorderRadius? borderRadius;

  const EmptyTextButton(
      {Key? key,
      required this.onPressed,
      required this.child,
      this.borderColor = Colors.orange,
      this.borderRadius,
      this.height = 64,
      this.width = 160})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 2),
          borderRadius: borderRadius ?? BorderRadius.circular(6),
        ),
        child: Center(child: child),
      ),
    );
  }
}
