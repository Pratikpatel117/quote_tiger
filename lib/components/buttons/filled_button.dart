import 'package:flutter/material.dart';

class FilledTextButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String message;
  final double width;
  final double height;
  final double fontSize;

  const FilledTextButton(
      {Key? key,
      required this.onPressed,
      required this.message,
      this.width = 160,
      this.height = 64,
      this.fontSize = 18})
      : super(key: key);

  @override
  State<FilledTextButton> createState() => _FilledTextButtonState();
}

class _FilledTextButtonState extends State<FilledTextButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: widget.onPressed,
        child: Ink(
          width: widget.width,
          height: widget.height,
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
          child: Center(
            child: Text(
              widget.message,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

bool _checkStopValue(List<double> stops) {
  for (var item in stops) {
    if (!(0 <= item && item <= 1)) {
      return false;
    }
  }
  return true;
}

class CustomFilledButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double width;
  final double height;
  final List<Color> fillColors;
  final List<double> stops;
  final Widget child;

  CustomFilledButton(
      {Key? key,
      required this.onPressed,
      required this.child,
      this.stops = const [0.5, 0.9],
      this.fillColors = const [
        Color(0xFFFCA205),
        Color(0xFFFFC55F),
      ],
      this.width = 160,
      this.height = 64})
      : assert(fillColors.length == stops.length),
        assert(_checkStopValue(stops)),
        super(key: key);

  @override
  State<CustomFilledButton> createState() => _CustomFilledButtonState();
}

class _CustomFilledButtonState extends State<CustomFilledButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: widget.onPressed,
        child: Ink(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: widget.stops,
                colors: widget.fillColors,
              )),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}
