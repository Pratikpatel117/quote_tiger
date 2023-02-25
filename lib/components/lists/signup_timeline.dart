import 'package:flutter/material.dart';

import 'package:quote_tiger/components/icons/qicon.dart';

enum ItemState { finished, pending, selected }

class SignUpSteps extends StatelessWidget {
  final int currentIndex;
  const SignUpSteps({Key? key, required this.currentIndex}) : super(key: key);

  ItemState getState(int index) {
    if (currentIndex > index) {
      return ItemState.finished;
    }
    if (currentIndex == index) {
      return ItemState.selected;
    }
    if (currentIndex < index) {
      return ItemState.pending;
    }
    return ItemState.pending;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TimelineItem(
          index: 1,
          state: getState(1),
        ),
        TimelineSeparator(
          itemState: getState(2),
        ),
        TimelineItem(
          index: 2,
          state: getState(2),
        ),
        TimelineSeparator(
          itemState: getState(3),
        ),
        TimelineItem(
          index: 3,
          state: getState(3),
        )
      ],
    );
  }
}

class ItemTimeline {
  final int currentIndex;
  final int itemCount;

  final Axis axis;
  const ItemTimeline(
      {Key? key,
      required this.currentIndex,
      required this.itemCount,
      required this.axis});
}

class TimelineSeparator extends StatelessWidget {
  final ItemState itemState;
  const TimelineSeparator({Key? key, required this.itemState})
      : super(key: key);

  Color stateToColor() {
    switch (itemState) {
      case ItemState.finished:
        return const Color(0xFF01F619);
      case ItemState.selected:
        return const Color(0xFFFCA205);
      default:
        return const Color(0xFFD5D5D7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 61,
          height: itemState == ItemState.pending ? 4 : 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: stateToColor(),
          ),
        ),
      ),
    );
  }
}

class TimelineItem extends StatelessWidget {
  final int index;
  final ItemState state;
  final Color primaryColor;
  final Color secondaryColor;
  final Color unselectedPrimaryColor;
  final Color unselectedSecondaryColor;
  final Color finishedPrimaryColor;
  final Color finishedSecondaryColor;

  final double size;

  const TimelineItem({
    Key? key,
    required this.index,
    required this.state,
    this.primaryColor = const Color(0xFFFCA205),
    this.secondaryColor = const Color(0xFFFFF6E6),
    this.unselectedPrimaryColor = const Color(0xFFD5D5D7),
    this.unselectedSecondaryColor = Colors.white,
    this.finishedPrimaryColor = const Color(0xFF01F619),
    this.finishedSecondaryColor = Colors.white,
    this.size = 60,
  }) : super(key: key);

  Color stateToPrimaryColor() {
    switch (state) {
      case ItemState.finished:
        return finishedPrimaryColor;
      case ItemState.selected:
        return primaryColor;
      default:
        return unselectedPrimaryColor;
    }
  }

  Color stateToSecondaryColor() {
    switch (state) {
      case ItemState.finished:
        return finishedSecondaryColor;
      case ItemState.selected:
        return secondaryColor;
      default:
        return unselectedSecondaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(color: stateToPrimaryColor(), width: 3),
          borderRadius: BorderRadius.circular(40),
          color: stateToSecondaryColor(),
        ),
        child: Center(
          child: state == ItemState.finished
              ? QIcon(QIcons.check)
              : Text(
                  '$index',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: size / 3,
                    color: stateToPrimaryColor(),
                  ),
                ),
        ),
      ),
    );
  }
}
